`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/11 20:23:31
// Design Name: 
// Module Name: CPUControl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CPUControl(
    input count_in,
    //指令相关信息
    input [5:0] ins,
    input [4:0] rsc,
    input [4:0] rtc,
    input [4:0] rdc,

    input isBranch,
    input E_isGoto,
    //EXE MEM级的寄存器信息，及前1/2条的数据相关（WB级不影响）
    input [4:0] exe_regfiles_addr,//EXE级寄存器的regfiles写入地址
    input [4:0] mem_regfiles_addr,//MEM级寄存器的写入地址
	
    input Ew_rf,
    input Mw_rf,
    input Ew_hi,
	input Mw_hi,
    input Ew_lo,
	input Mw_lo,
	input Ew_cp0,
	input Mw_cp0,

    //流水线暂停相关
    output stall,
    output isGoto,
    output count,

    //寄存器写使能
    output w_rf,
    output w_cp0,
    output w_hi,
    output w_lo,
    output w_dm,
	output dm_cs,
    output mfc0,
    output mtc0,
    output excption,
    output eret,
    output [4:0] cause,

    //多路选择器信号
    output [2:0] rd_choose,
    output [2:0] pc_choose,
    output [1:0] hi_choose,
    output [1:0] lo_choose,
    output alu_a_choose,
    output alu_b_choose,
    output [1:0] dmem_bit,
    //regfile
    output [4:0] rd_addr,
    //ALU
    output [3:0] aluc,

    output sign,
    output div,
    output sign_ext,
    output is_lui,
    //Branch
    output [1:0] branch_request,
    
    output [1:0] forward,
    output conflict_rs,
    output conflict_rt
    );

    //Branch
    assign branch_request[0]=(ins==44)||(ins==53);
    assign branch_request[1]=(ins==45)||(ins==53);

	wire mfhi,mflo;    
	assign mfhi = (ins==18);
	assign mflo = (ins==19);

    //流水线冲突相关
	wire r_rs;
	wire r_rt;
    wire find_conflict;
    wire visit_mem;

	assign r_rs=~(ins==10||ins==11||ins==12||ins==17||ins==18||ins==19||ins==22||ins==23||
				ins==34||ins==48||ins==49||ins==50||ins==51||ins==52);
	assign r_rt=(ins==0||ins==1||ins==2||ins==3||ins==4||ins==5||ins==6||ins==7||ins==8||
				ins==9||ins==10||ins==11||ins==12||ins==13||ins==14||ins==15||ins==23||ins==25
				||ins==26||ins==27||ins==28||ins==40||ins==41||ins==42||ins==43||ins==44||ins==53);
    assign visit_mem = ins==40||ins==41||ins==42;
    assign find_conflict = (Ew_rf && exe_regfiles_addr && ((r_rs)&&(rsc==exe_regfiles_addr)||(r_rt)&&(rtc==exe_regfiles_addr)))//与i-1条指令相关
				|| (Mw_rf && mem_regfiles_addr && ((r_rs)&&(rsc==mem_regfiles_addr)||(r_rt)&&(rtc==mem_regfiles_addr)))//与i-2条指令相关
				|| (Ew_hi && mfhi) ||(Mw_hi && mfhi)//hi寄存器WR
				|| (Ew_lo && mflo) || (Mw_lo && mflo)//lo寄存器WR
				|| (Ew_cp0 && (mfc0||eret)) || (Mw_cp0 && (mfc0||eret));//cp0 
    assign stall = find_conflict && forward[0] && visit_mem;
    assign count = 1'b1 && stall;

    assign forward[0] = (Ew_rf && exe_regfiles_addr && ((r_rs)&&(rsc==exe_regfiles_addr)||(r_rt)&&(rtc==exe_regfiles_addr)))
                        || (Ew_hi && mfhi) || (Ew_lo && mflo) || (Ew_cp0 && (mfc0||eret));

    assign forward[1] = (Mw_rf && mem_regfiles_addr && ((r_rs)&&(rsc==mem_regfiles_addr)||(r_rt)&&(rtc==mem_regfiles_addr)))
                        || (Mw_hi && mfhi) || (Mw_lo && mflo) || (Mw_cp0 && (mfc0||eret));

    assign conflict_rs = ((r_rs)&&(rsc==exe_regfiles_addr)) || ((r_rs)&&(rsc==mem_regfiles_addr));
    assign conflict_rt = ((r_rt)&&(rtc==exe_regfiles_addr)) || ((r_rt)&&(rtc==mem_regfiles_addr));

    //寄存器写使能
    assign w_rf=~(ins==16||ins==20||ins==21||ins==23||ins==26||ins==27
                ||ins==28||ins==40||ins==41||ins==42||ins==43||ins==44||ins==45
                ||ins==48||ins==50||ins==51||ins==52||ins==53);
    assign w_cp0=(ins==23||ins==50||ins==51||ins==52||ins==53);
    assign w_dm=(ins==40||ins==41||ins==42);
	assign dm_cs=(ins==35||ins==36||ins==37||ins==38||ins==39||ins==40||ins==41||ins==42);
    assign w_hi=(ins==20||ins==25||ins==26||ins==27||ins==28);
    assign w_lo=(ins==21||ins==25||ins==26||ins==27||ins==28);
    assign mfc0=(ins==22);
    assign mtc0=(ins==23);
    assign exception=(ins==50||ins==51||ins==52||(ins==53&&isBranch));
    assign eret=(ins==52);
    assign cause=(ins==50) ? 5'b01001 : ((ins==51) ? 5'b01000 : ((ins==53) ? 5'b01101 : 5'bz));

    assign sign=(ins==25||ins==27);
    assign div=(ins==27||ins==28);
    assign sign_ext=(ins==29)||(ins==30)||(ins==46)||(ins==47);
    assign is_lui=(ins==34);

    //多路选择器信号
	assign rd_choose[0]=(ins==19||ins==25||ins==35||ins==36||ins==37||ins==38||ins==39);        
    assign rd_choose[1]=(ins==18||ins==19||ins==24);
    assign rd_choose[2]=(ins==22||ins==24||ins==35||ins==36||ins==37||ins==38||ins==39);

    assign pc_choose[0]=((ins==43&&isBranch)||(ins==44&&isBranch)||(ins==45&&isBranch)||ins==48||ins==49||ins==52);        
    assign pc_choose[1]=(ins==16||ins==17||ins==48||ins==49);
    assign pc_choose[2]=(ins==50||ins==51||ins==52||(ins==53&&isBranch));
	

    assign hi_choose[0]=(ins==25||ins==26);
    assign hi_choose[1]=(ins==27||ins==28);
    assign lo_choose[0]=(ins==25||ins==26);
    assign lo_choose[1]=(ins==27||ins==28);
    
    assign alu_a_choose=(ins==10||ins==11||ins==12||ins==13||ins==14||ins==15);
    assign alu_b_choose=(ins==29||ins==30||ins==31||ins==32||ins==33||ins==34||ins==45||
						ins==35||ins==36||ins==37||ins==38||ins==39||ins==40
						||ins==41||ins==42||ins==45||ins==46||ins==47);

    assign dmem_bit[0]=(ins==40||ins==42);
    assign dmem_bit[1]=(ins==40);
    
    //regfile
    wire [1:0] mux_rdc;
    assign mux_rdc[0]=(ins==22||ins==29||ins==30||ins==31||ins==32||ins==33||ins==34||ins==35||
    		ins==36||ins==37||ins==38||ins==39||ins==46||ins==47);
    assign mux_rdc[1]=(ins==49);
    assign rd_addr = mux_rdc[1] ? 5'b11111 : (mux_rdc[0] ? rtc :rdc);
    //ALU
    assign aluc[0]=(ins==2||ins==3||ins==5||ins==7||ins==8||ins==11||ins==14||ins==32||ins==46);
    assign aluc[1]=(ins==1||ins==3||ins==6||ins==7||ins==8||ins==9||ins==10||ins==13||ins==29||
            ins==33||ins==46||ins==47);
    assign aluc[2]=(ins==4||ins==5||ins==6||ins==7||ins==10||ins==11||ins==12||
            ins==13||ins==14||ins==15||ins==31||ins==32||ins==33);
    assign aluc[3]=(ins==8||ins==9||ins==10||ins==11||ins==12||ins==13||
            ins==14||ins==15||ins==46||ins==47);
endmodule
