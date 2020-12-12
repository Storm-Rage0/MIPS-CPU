`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/11 21:12:16
// Design Name: 
// Module Name: ID_EX
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
ID/EX中间部件，锁存寄存器写入信号，多路选择器信号等控制信号
***************************************/

module ID_EX(
    input clk,
    input rst,
    /*********ID级数据**********/
    input [31:0] id_pc_plus4,//imem地址pc
    //regfiles读数据
    input [31:0] id_rs_data,
    input [31:0] id_rt_data,
    //寄存器数据相关
    input [31:0] id_imm_data,//立即数
    input [31:0] id_cp0_data,
    input [31:0] id_hi_data,
    input [31:0] id_lo_data,

    input [4:0] id_regfiles_waddr,//寄存器堆写入地址
    //寄存器写入使能
    input id_w_regfiles,
    input id_w_hi,
    input id_w_lo,
    input id_w_dmem,
    input id_isGoto,
    //标志位
    input id_sign,id_div,
    
    //多路选择器信号
    input [3:0] id_aluc,
    input id_alu_a_choose,id_alu_b_choose,
    input [1:0] id_dmemlength_choose,
    input [1:0] id_hi_choose,
    input [1:0] id_lo_choose,
    input [2:0] id_rd_choose,//寄存器堆写入选择信号

    /*********IF级数据*********/
    output reg [31:0] ex_pc_plus4,//imem地址pc
    //regfiles读数据
    output reg [31:0] ex_rs_data,
    output reg [31:0] ex_rt_data,
    //寄存器数据相关
    output reg [31:0] ex_imm_data,//立即数
    output reg [31:0] ex_cp0_data,
    output reg [31:0] ex_hi_data,
    output reg [31:0] ex_lo_data,

    output reg [4:0] ex_regfiles_waddr,//寄存器堆写入地址
    //寄存器写入使能
    output reg ex_w_regfiles,
    output reg ex_w_hi,
    output reg ex_w_lo,
    output reg ex_w_dmem,
    output reg ex_isGoto,
    //标志位
    output reg ex_sign,ex_div,
    
    //多路选择器信号
    output reg [3:0] ex_aluc,
    output reg ex_alu_a_choose,ex_alu_b_choose,
    output reg [1:0] ex_dmemlength_choose,
    output reg [1:0] ex_hi_choose,
    output reg [1:0] ex_lo_choose,
    output reg [2:0] ex_rd_choose//寄存器堆写入选择信号
    );

    always @ (posedge clk or posedge rst)begin
        if(rst)begin
            ex_pc_plus4 <= 32'b0; 
            //regfiles读数据
            ex_rs_data <= 32'b0; 
            ex_rt_data <= 32'b0; 
            //寄存器数据相关
            ex_imm_data <= 32'b0; 
            ex_cp0_data <= 32'b0; 
            ex_hi_data <= 32'b0; 
            ex_lo_data <= 32'b0; 

            ex_regfiles_waddr <= 5'b0; 
            //寄存器写入使能
            ex_w_regfiles <= 1'b0; 
            ex_w_hi <= 1'b0; 
            ex_w_lo <= 1'b0; 
            ex_w_dmem <= 1'b0; 
            ex_isGoto <= 1'b0; 
            //标志位
            ex_sign <= 1'b0; 
            ex_div <= 1'b0; 
    
            //多路选择器信号
            ex_aluc <= 4'b0; 
            ex_alu_a_choose <= 1'b0; 
            ex_alu_b_choose <= 1'b0; 
            ex_dmemlength_choose <= 2'b0; 
            ex_hi_choose <= 2'b0; 
            ex_lo_choose <= 2'b0; 
            ex_rd_choose <= 3'b0; 
        end

        else begin
            ex_pc_plus4 <= id_pc_plus4; 
            //regfiles读数据
            ex_rs_data <= id_rs_data; 
            ex_rt_data <= id_rt_data; 
            //寄存器数据相关
            ex_imm_data <= id_imm_data; 
            ex_cp0_data <= id_cp0_data; 
            ex_hi_data <= id_hi_data; 
            ex_lo_data <= id_lo_data; 

            ex_regfiles_waddr <= id_regfiles_waddr; 
            //寄存器写入使能
            ex_w_regfiles <= id_w_regfiles; 
            ex_w_hi <= id_w_hi; 
            ex_w_lo <= id_w_lo; 
            ex_w_dmem <= id_w_dmem; 
            ex_isGoto <= id_isGoto; 
            //标志位
            ex_sign <= id_sign; 
            ex_div <= id_div; 
    
            //多路选择器信号
            ex_aluc <= id_aluc; 
            ex_alu_a_choose <= id_alu_a_choose; 
            ex_alu_b_choose <= id_alu_b_choose; 
            ex_dmemlength_choose <= id_dmemlength_choose; 
            ex_hi_choose <= id_hi_choose; 
            ex_lo_choose <= id_lo_choose; 
            ex_rd_choose <= id_rd_choose; 
        end
    end
endmodule
