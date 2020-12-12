`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/07 17:36:19
// Design Name: 
// Module Name: IF_ID
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
IF/ID中间部件，锁存pc+4的值和指令
***************************************/

module IF_ID(
    input clk,
    input rst,
    input wena,
    //IF信号输入
    input [31:0] pc_plus_4,
    input [31:0] inst,
    //传递至ID
    output reg [31:0] id_pc_plus_4,
    output reg [31:0] id_inst
    );

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            id_pc_plus_4 <= 32'h0000_0000;
            id_inst <=32'b0000_0000;
        end
        else if (wena) begin
            id_pc_plus_4 <= pc_plus_4;
            id_inst <= inst;
        end
        else begin
            id_pc_plus_4 <= id_pc_plus_4;
            id_inst <= id_inst;
        end
    end
    
endmodule
