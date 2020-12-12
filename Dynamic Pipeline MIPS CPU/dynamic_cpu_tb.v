`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/24 21:21:16
// Design Name: 
// Module Name: dynamic_cpu_tb
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


module dynamic_cpu_tb();


    reg clk_in,reset;
    
    wire [31:0] inst;
    wire [31:0] pc;


    dynamic_cpu uut(clk_in,reset,pc,inst);

    wire [31:0] a_0=uut.mem.dmem.array[0];
    wire [31:0] b_0=uut.mem.dmem.array[256];
    wire [31:0] c_0=uut.mem.dmem.array[512];
    wire [31:0] d_0=uut.mem.dmem.array[768];

    wire [31:0] a_10=uut.mem.dmem.array[40];
    wire [31:0] b_10=uut.mem.dmem.array[296];
    wire [31:0] c_10=uut.mem.dmem.array[552];
    wire [31:0] d_10=uut.mem.dmem.array[808];
    wire [31:0] a_20=uut.mem.dmem.array[80];
    wire [31:0] b_40=uut.mem.dmem.array[416];
    wire [31:0] c_50=uut.mem.dmem.array[712];
    wire [31:0] d_30=uut.mem.dmem.array[888];
    wire [31:0] d_59=uut.mem.dmem.array[1004];
    wire [31:0] endflag=uut.id.regfile_heap.array_reg[31];

    wire [31:0] tb_pcin=uut.pc_reg.data_in;
    wire [31:0] tb_pcreg=uut.pc_reg.data_out;
    wire [31:0] tb_npc=uut.npc;
    wire [31:0] tb_idins=uut.id_inst;
    wire [31:0] tb_idrs=uut.id_rs_data;
    wire [31:0] tb_idimm=uut.id_imm;
    // wire [31:0] tb_exrs=uut.ex_rs_data;
    // wire [31:0] tb_eximm=uut.ex_imm;
    // wire [63:0] tb_exmul=uut.ex_mult;
    // wire [31:0] tb_memalu=uut.mem_alu;
    // wire [31:0] tb_wbalu=uut.wb_alu;
    // wire [63:0] tb_wbmul=uut.wb_mult;
    // wire [2:0] tb_wbrdchoose=uut.wb_rd_choose;
    // wire [31:0] tb_wb_rfwdata=uut.wdata_regfiles;
    // wire [2:0] tb_rd_choose=uut.id_rd_choose;
    // wire [31:0] tb_rt_data=uut.id_rt_data;
    // wire  tb_id_wdmem=uut.id_w_dmem;
    // wire  tb_idrf_wena=uut.id_w_regfiles;
    // wire tb_wbrf_wena=uut.wb_wena_rf;
    // wire [31:0] tb_immdata=uut.id_imm;
    // wire [15:0] tb_insimm=uut.id.inst_imm;
    // wire [31:0] tb_id_ins=uut.id.inst;
    wire [31:0] tb_data_dmem=uut.mem.dmem.data_out;
    wire [25:0] tb_target=uut.id.inst[25:0];
    wire [27:0] tb_la_target={uut.id.inst[25:0],2'b0};
    wire [31:0] tb_ex_alu=uut.ex.alu_odata;
    wire [2:0] tb_pc_choose=uut.pc_choose;
    // wire [31:0] tb_ifidpcin=uut.if_id.id_pc_plus_4;
    // wire [31:0] tb_bpc=uut.id.pc_branch;
    // wire [31:0] tb_jpc=uut.id.pc_jump;
    // wire [31:0] tb_rpc=uut.id.pc_regfiles;
    wire tb_stall=uut.is_stall;
    wire tb_pcena=uut.pc_wena;
    wire [1:0]tb_stallcount=uut.id.cpu_ctrl.count_in;
    wire [31:0] tb_pc4=uut.id_pc_plus4;
    // wire [31:0] tb_ext18=uut.id.ext_18;
    integer file_output;

    initial begin

        file_output=$fopen("result_pre.txt");

        clk_in=0;
        reset=1;
        
        #10;
        reset=0;
    end
    initial forever #20 clk_in=~clk_in;

    always@(posedge clk_in) begin
        $fdisplay(file_output, "pc: %h", pc);
        $fdisplay(file_output, "instr: %h", inst);
        
        //$fdisplay(file_output, "cp0_reg12: %h", dynamic_cpu_tb.uut.id.cpu_cp0.CP0_array[12]);
        //$fdisplay(file_output, "cp0_reg13: %h", dynamic_cpu_tb.uut.id.cpu_cp0.CP0_array[13]);
        //$fdisplay(file_output, "cp0_reg14: %h", dynamic_cpu_tb.uut.id.cpu_cp0.CP0_array[14]);
        $fdisplay(file_output, "forward: %h", dynamic_cpu_tb.uut.id.forward);
        //$fdisplay(file_output, "alu_a: %h", dynamic_cpu_tb.uut.wdata_regfiles);
        //$fdisplay(file_output, "alu_b: %h", dynamic_cpu_tb.uut.wdata_regfiles);
        $fdisplay(file_output, "wdata: %h", dynamic_cpu_tb.uut.wdata_regfiles);
        $fdisplay(file_output, "waddr: %h", dynamic_cpu_tb.uut.waddr_regfiles);
        $fdisplay(file_output, "regfile0: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[0]);
        $fdisplay(file_output, "regfile1: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[1]);
        $fdisplay(file_output, "regfile2: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[2]);
        $fdisplay(file_output, "regfile3: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[3]);
        $fdisplay(file_output, "regfile4: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[4]);
        $fdisplay(file_output, "regfile5: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[5]);
        $fdisplay(file_output, "regfile6: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[6]);
        $fdisplay(file_output, "regfile7: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[7]);
        $fdisplay(file_output, "regfile8: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[8]);
        $fdisplay(file_output, "regfile9: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[9]);
        $fdisplay(file_output, "regfile10: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[10]);
        $fdisplay(file_output, "regfile11: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[11]);
        $fdisplay(file_output, "regfile12: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[12]);
        $fdisplay(file_output, "regfile13: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[13]);
        $fdisplay(file_output, "regfile14: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[14]);
        $fdisplay(file_output, "regfile15: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[15]);
        $fdisplay(file_output, "regfile16: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[16]);
        $fdisplay(file_output, "regfile17: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[17]);
        $fdisplay(file_output, "regfile18: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[18]);
        $fdisplay(file_output, "regfile19: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[19]);
        $fdisplay(file_output, "regfile20: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[20]);
        $fdisplay(file_output, "regfile21: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[21]);
        $fdisplay(file_output, "regfile22: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[22]);
        $fdisplay(file_output, "regfile23: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[23]);
        $fdisplay(file_output, "regfile24: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[24]);
        $fdisplay(file_output, "regfile25: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[25]);
        $fdisplay(file_output, "regfile26: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[26]);
        $fdisplay(file_output, "regfile27: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[27]);
        $fdisplay(file_output, "regfile28: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[28]);
        $fdisplay(file_output, "regfile29: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[29]);
        $fdisplay(file_output, "regfile30: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[30]);
        $fdisplay(file_output, "regfile31: %h", dynamic_cpu_tb.uut.id.regfile_heap.array_reg[31]);
    end

endmodule

