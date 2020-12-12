`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/09 18:37:17
// Design Name: 
// Module Name: Ext_16
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

module Ext_16(
    input [15:0]data_in,
    input sign,
    input is_lui,
    output [31:0]data_out
    );
    assign data_out= is_lui ? {data_in,16'b0} : (sign ? {{16{data_in[15]}},data_in} : {{16{1'b0}},data_in});
    endmodule