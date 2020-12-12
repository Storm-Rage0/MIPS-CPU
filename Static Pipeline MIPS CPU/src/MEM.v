`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/16 11:24:21
// Design Name: 
// Module Name: MEM
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

/***********************
MEM级部件，对DMEM进行操作
************************/

module MEM(
    input clk,
    input [31:0] alu,
    input [31:0] rt_data,
    input w_dmem,
    //多路选择器信号
    input [1:0] dmemlength_choose,
    output [31:0] dmem_odata,//dmem输出信号

    input [1:0] array_choose,
    input [5:0] item_choose,
    output [31:0] showdata
    );

    //DMEM dmem(clk,1'b1,w_dmem,1'b1,alu[10:0],rt_data,dmemlength_choose,dmem_odata);
    DMEM1 dmem(clk,1'b1,w_dmem,1'b1,alu[10:0],rt_data,dmem_odata,array_choose,item_choose,showdata);
    
endmodule
