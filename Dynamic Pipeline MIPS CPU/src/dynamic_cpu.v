`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/24 21:06:13
// Design Name: 
// Module Name: dynamic_cpu
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


module dynamic_cpu(
    input clk,
    input rst,
    input [1:0] array_choose,
    input [5:0] item_choose,
    output [31:0] pc,
    output [31:0] inst,
    output [31:0] showdata
    );

    // wire [1:0] array_choose;
    // wire [5:0] item_choose;
    // wire [31:0] showdata;
    //���׶ε�pcֵ
    wire [31:0] current_pc;
    wire [31:0] npc;
    wire [31:0] pc_branch;
    wire [31:0] pc_jump;
    wire [31:0] pc_regfiles;
    wire [31:0] pc_cp0;
    wire [31:0] pc_plus4;
    wire [31:0] id_pc_plus4;
    wire [31:0] ex_pc_plus4;
    wire [31:0] mem_pc_plus4;
    wire [31:0] wb_pc_plus4;

    //ָ��
    wire [31:0] if_ins;
    wire [31:0] id_inst;

    //id��ex�������ݣ��Ĵ���
    wire [31:0] id_rs_data;
    wire [31:0] id_rt_data;
    wire [31:0] id_imm;
    wire [31:0] id_cp0_data;
    wire [31:0] id_hi_data;
    wire [31:0] id_lo_data;
    wire [31:0] ex_rs_data;
    wire [31:0] ex_rt_data;
    wire [31:0] ex_imm;
    wire [31:0] ex_cp0_data;
    wire [31:0] ex_hi_data;
    wire [31:0] ex_lo_data;
    //wire [31:0] mem_rt_data;
    //mem��dmem������
    wire [31:0] mem_dmem_odata;
    wire [31:0] wb_dmem_odata;
    //wire [31:0] rf_wdata;

    wire [4:0] drn;
    wire [4:0] ern;
    wire [4:0] mrn;
    wire [4:0] wrn;

    wire [3:0] id_aluc;//daluc=aluc
    wire [3:0] ex_aluc;

    wire [2:0] pc_choose;
    wire pc_wena;

    //id���Ĵ�����д�ź�
    wire id_w_regfiles;
    wire id_w_hi;
    wire id_w_lo;
    wire id_w_dmem;
    wire id_isGoto;

    wire ex_w_regfiles;
    wire ex_w_hi;
    wire ex_w_lo;
    wire ex_w_dmem;
    wire ex_isGoto;
    //��־λ
    wire id_sign,id_isdiv;
    wire ex_sign,ex_isdiv;
    
    //��·ѡ������
    wire id_alu_a_choose,id_alu_b_choose;
    wire [1:0] id_dmemlength_choose;
    wire [1:0] id_hi_choose;
    wire [1:0] id_lo_choose;
    wire [2:0] id_rd_choose;//д���ַѡ��

    wire ex_alu_a_choose,ex_alu_b_choose;
    wire [1:0] ex_dmemlength_choose;
    wire [1:0] ex_hi_choose;
    wire [1:0] ex_lo_choose;
    wire [2:0] ex_rd_choose;//

    //EX_MEM
    wire [63:0] ex_mult;
    wire [63:0] ex_div;
    wire [31:0] ex_clz;
    wire [31:0] ex_alu;

    wire [63:0] mem_mult;
    wire [63:0] mem_div;
    wire [31:0] mem_clz;
    wire [31:0] mem_alu;

    wire [31:0] mem_rs_data;
    wire [31:0] mem_rt_data;
    wire [31:0] mem_cp0_data;
    wire [31:0] mem_hi_data;
    wire [31:0] mem_lo_data;
    wire mem_w_regfiles;
    wire mem_w_hi;
    wire mem_w_lo;
    wire mem_w_dmem;
    wire mem_isGoto;
    wire mem_sign;
    wire [1:0] mem_dmemlength_choose;
    wire [1:0] mem_hi_choose;
    wire [1:0] mem_lo_choose;
    wire [2:0] mem_rd_choose;//

    //MEM_WB
    wire [63:0] wb_mult;
    wire [63:0] wb_div;
    wire [31:0] wb_clz;
    wire [31:0] wb_alu;

    wire [31:0] wb_rs_data;
    wire [31:0] wb_rt_data;
    wire [31:0] wb_cp0_data;
    wire [31:0] wb_hi_data;
    wire [31:0] wb_lo_data;

    wire wb_w_regfiles;
    wire wb_w_hi;
    wire wb_w_lo;
    wire [1:0] wb_hi_choose;
    wire [1:0] wb_lo_choose;
    wire [2:0] wb_rd_choose;//

    //wb����д������
    wire [31:0] wdata_regfiles;
    wire [31:0] wdata_hi;
    wire [31:0] wdata_lo;
    wire [4:0] waddr_regfiles;
    wire wb_wena_rf,wb_wena_hi,wb_wena_lo;

    //�Ƿ�����pc
    wire is_stall;
    wire disable_pc;
    assign disable_pc = (pc_choose!=0);
    assign pc_wena = (is_stall==0);
    pcreg pc_reg(~clk,rst,pc_wena,npc,current_pc);

    IF cpu_if(current_pc,pc_cp0,pc_branch,pc_regfiles,pc_jump,pc_choose,disable_pc,npc,pc_plus4,if_ins);
    
    IF_ID if_id(~clk,rst,pc_wena,pc_plus4,if_ins,id_pc_plus4,id_inst);
    
    ID id(clk,rst,id_pc_plus4,id_inst,ern,mrn,ex_w_regfiles,mem_w_regfiles,ex_w_hi,mem_w_hi,ex_w_lo,mem_w_lo,wdata_regfiles,wdata_hi,wdata_lo,waddr_regfiles,wb_wena_rf,
            wb_wena_hi,wb_wena_lo,ex_isGoto,pc_cp0,pc_regfiles,pc_branch,pc_jump,id_rs_data,id_rt_data,id_imm,id_cp0_data,id_hi_data,id_lo_data,/*id_pc_plus4,*/
            drn,id_sign,id_isdiv,id_aluc,id_w_hi,id_w_lo,id_w_regfiles,id_w_dmem,id_alu_a_choose,id_alu_b_choose,id_dmemlength_choose,id_hi_choose,id_lo_choose,
            id_rd_choose,pc_choose,is_stall,id_isGoto,ex_alu,ex_mult[31:0],ex_clz,ex_rd_choose,mem_alu,mem_mult[31:0],mem_clz,mem_dmem_odata,mem_rd_choose);
    
    ID_EX id_ex(~clk,rst,id_pc_plus4,id_rs_data,id_rt_data,id_imm,id_cp0_data,id_hi_data,id_lo_data,drn,id_w_regfiles,id_w_hi,id_w_lo,
                id_w_dmem,id_isGoto,id_sign,id_isdiv,id_aluc,id_alu_a_choose,id_alu_b_choose,id_dmemlength_choose,id_hi_choose,id_lo_choose,id_rd_choose,
                ex_pc_plus4,ex_rs_data,ex_rt_data,ex_imm,ex_cp0_data,ex_hi_data,ex_lo_data,ern,ex_w_regfiles,ex_w_hi,ex_w_lo,ex_w_dmem,ex_isGoto,
                ex_sign,ex_isdiv,ex_aluc,ex_alu_a_choose,ex_alu_b_choose,ex_dmemlength_choose,ex_hi_choose,ex_lo_choose,ex_rd_choose);
    
    EX ex(ex_rs_data,ex_rt_data,ex_imm,ex_sign,ex_isdiv,ex_aluc,ex_alu_a_choose,ex_alu_b_choose,ex_mult,ex_div[63:32],ex_div[31:0],ex_clz,ex_alu);
    
    EX_MEM ex_mem(~clk,rst,ex_mult,ex_div,ex_clz,ex_alu,ex_pc_plus4,ex_rs_data,ex_rt_data,ex_cp0_data,ex_hi_data,ex_lo_data,ern,ex_w_regfiles,
                ex_w_hi,ex_w_lo,ex_w_dmem,ex_isGoto,ex_sign,ex_dmemlength_choose,ex_hi_choose,ex_lo_choose,ex_rd_choose,mem_mult,mem_div,mem_clz,mem_alu,
                mem_pc_plus4,mem_rs_data,mem_rt_data,mem_cp0_data,mem_hi_data,mem_lo_data,mrn,mem_w_regfiles,mem_w_hi,mem_w_lo,mem_w_dmem,mem_isGoto,mem_sign,
                mem_dmemlength_choose,mem_hi_choose,mem_lo_choose,mem_rd_choose);
    
    MEM mem(~clk,mem_alu,mem_rt_data,mem_w_dmem,mem_dmemlength_choose,mem_dmem_odata,array_choose,item_choose,showdata);
    
    MEM_WB mem_wb(~clk,rst,mem_mult,mem_div,mem_clz,mem_alu,mem_dmem_odata,mem_pc_plus4,mem_rs_data,mem_rt_data,mem_cp0_data,mem_hi_data,mem_lo_data,mrn,
                mem_w_regfiles,mem_w_hi,mem_w_lo,mem_hi_choose,mem_lo_choose,mem_rd_choose,wb_mult,wb_div,wb_clz,wb_alu,wb_dmem_odata,wb_pc_plus4,wb_rs_data,
                wb_rt_data,wb_cp0_data,wb_hi_data,wb_lo_data,wrn,wb_w_regfiles,wb_w_hi,wb_w_lo,wb_hi_choose,wb_lo_choose,wb_rd_choose);
    
    WB wb(wb_mult,wb_div,wb_clz,wb_alu,wb_dmem_odata,wb_rs_data,wb_rt_data,wb_cp0_data,wb_hi_data,wb_lo_data,wrn,wb_w_regfiles,wb_w_hi,wb_w_lo,wb_hi_choose,
        wb_lo_choose,wb_rd_choose,wdata_regfiles,wdata_hi,wdata_lo,waddr_regfiles,wb_wena_rf,wb_wena_hi,wb_wena_lo);

    assign pc = disable_pc ? 32'b0 : current_pc;
    assign inst=if_ins;
endmodule
