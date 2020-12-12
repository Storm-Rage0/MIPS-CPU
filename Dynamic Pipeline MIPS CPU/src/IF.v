`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/08 14:55:14
// Design Name: 
// Module Name: IF
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
取址阶段部件，选择npc，并且从IMEM中取出指令
***************************************/


module IF(
    input [31:0] pc,//curent pc
    input [31:0] cpc,
    input [31:0] pc_branch,
    input [31:0] pc_regfiles,
    input [31:0] pc_jump,
    input [2:0] pc_choose,
    input disable_pc,
    output [31:0] npc,//actually next pc
    output [31:0] pc_plus_4,//current pc+4
    output [31:0] instruction
    );

    wire [31:0] inst_from_imem;
    assign pc_plus_4 = pc + 32'h4;
    MUX_8to1 pc_mux(pc_plus_4,pc_branch,pc_regfiles,pc_jump,32'h4/*0x4,interrupt entrance*/,cpc,32'b0,32'b0,pc_choose,npc);
    IMEM_ip imem(pc[12:2],inst_from_imem);
    assign instruction = disable_pc ? (32'b0) : inst_from_imem;
endmodule
