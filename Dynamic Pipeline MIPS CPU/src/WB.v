`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/16 13:07:00
// Design Name: 
// Module Name: WB
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

/*********************************************************
WB级部件，MUX选择写入数据，将其与w使能信号，写入地址回传至ID级
**********************************************************/

module WB(
    //运算部件数据
    input [63:0] mult,
    input [63:0] div,
    input [31:0] clz,
    input [31:0] alu,
    //DMEM数据
    input [31:0] dmem_odata,

    //regfiles读数据
    input [31:0] rs_data,
    input [31:0] rt_data,
    //寄存器数据相关
    input [31:0] cp0_data,
    input [31:0] hi_data,
    input [31:0] lo_data,

    input [4:0] regfiles_waddr,//寄存器堆写入地址
    //寄存器写入使能
    input w_regfiles,
    input w_hi,
    input w_lo,

    //多路选择器信号
    input [1:0] hi_choose,
    input [1:0] lo_choose,
    input [2:0] rd_choose,//寄存器堆写入选择信号

    output [31:0] wdata_regfiles,
    output [31:0] wdata_hi,
    output [31:0] wdata_lo,
    output [4:0] waddr_regfiles,

    output wena_rf,
    output wena_hi,
    output wena_lo
    );

    //寄存器输入数据选择
    MUX_4to1 mux_hi(rs_data,mult[63:32],div[63:32],32'b0,hi_choose,wdata_hi);
    MUX_4to1 mux_lo(rs_data,mult[31:0],div[31:0],32'b0,lo_choose,wdata_lo);
    MUX_8to1 mux_regfiles(alu,mult[31:0],hi_data,lo_data,cp0_data,dmem_odata,clz,32'b0,rd_choose,wdata_regfiles);

    assign waddr_regfiles = regfiles_waddr;
    assign wena_hi = w_hi;
    assign wena_lo = w_lo;
    assign wena_rf = w_regfiles;
endmodule
