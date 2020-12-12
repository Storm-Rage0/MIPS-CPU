`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/08 21:48:50
// Design Name: 
// Module Name: II
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

module II(
    input [3:0] a,
    input [25:0] b,
    output [31:0] r
    );
    assign r = {a, b,2'b0};
endmodule
