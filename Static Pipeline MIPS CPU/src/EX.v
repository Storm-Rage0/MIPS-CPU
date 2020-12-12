`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/11 23:41:06
// Design Name: 
// Module Name: EX
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

/***************************************
EX级部件，处理计算级内容，实例化各个计算部件
***************************************/

module EX(
    /*********************
    输入信号，均由ID_EX寄存器传入
    ***********************/
    //寄存器读数据
    input [31:0] rs_data,
    input [31:0] rt_data,
    //寄存器数据相关
    input [31:0] imm_data,//立即数

    input sign,div,
    
    //多路选择器信号
    input [3:0] aluc,
    input alu_a_choose,alu_b_choose,
    /*******计算部件输出信号*******/
    output [63:0] mult_data,
    output [31:0] div_r,//余数
    output [31:0] div_q,//商
    output [31:0] clz_data,//CLZ module
    output [31:0] alu_odata//ALU outdata
    );

    (*MARK_DEBUG="true"*)wire [31:0] mux_alu_a;
    (*MARK_DEBUG="true"*)wire [31:0] mux_alu_b;
    //(*MARK_DEBUG="true"*)wire [31:0] mux_alu_odata;
    wire zero,carry,negative,overflow;//ALU标志位

    CLZ clz(rs_data,clz_data);

    //ALU
    MUX_2to1 mux_a(rs_data,{27'b0,imm_data[10:6]},alu_a_choose,mux_alu_a);
    MUX_2to1 mux_b(rt_data,imm_data,alu_b_choose,mux_alu_b);
    ALU alu(mux_alu_a,mux_alu_b,aluc,alu_odata,zero,carry,negative,overflow);

    //MULT,DIV
    wire [63:0] div_odata;
    MULT cpu_mult(rs_data,rt_data,sign,mult_data);
    DIV cpu_div(rs_data,rt_data,sign,div_odata);
    assign div_r = div_odata[63:32];
    assign div_q = div_odata[31:0];

    
endmodule
