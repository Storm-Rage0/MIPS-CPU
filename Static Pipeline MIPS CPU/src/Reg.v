`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/08 16:46:22
// Design Name: 
// Module Name: Reg
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


module Reg(
    input clk,
    input rst,//high level set zero
    input wena,//high level getin
    input [31:0] data_in,
    output reg [31:0] data_out
    );    
    //initial data_out<=32'h0000_0000;
    always @ (posedge clk or posedge rst)begin
        if (rst)
            data_out <= 0;
        else if (wena)
            data_out <= data_in;
        else
            data_out <= data_out;
     end
   
endmodule
