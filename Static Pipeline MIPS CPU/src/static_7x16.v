`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/03 17:23:45
// Design Name: 
// Module Name: static_7x16
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


module static_7x16(
    input clk,
    input reset,
    input [1:0] array_choose,
    input [5:0] item_choose,
    output [7:0] o_seg,//显示数字
	output [7:0] o_sel//选择数码管
    );
    wire clk_cpu;
    wire [31:0] pc;
    wire [31:0] inst;
    wire [31:0] odata;
    Divider #(4) divider_cpu(clk,reset,clk_cpu);
    static_cpu pipe_cpu(clk_cpu,reset,array_choose,item_choose,pc,inst,odata);
    seg7x16 seg_show(clk,reset,1'b1,odata,o_seg,o_sel);
endmodule
