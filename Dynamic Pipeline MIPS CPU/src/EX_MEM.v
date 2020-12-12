`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/16 10:56:40
// Design Name: 
// Module Name: EX_MEM
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
EX/MEM中间部件，锁存运算部件的结果与控制信号
***************************************/

module EX_MEM(
    input clk,
    input rst,
    /*********EX级数据**********/
    //运算部件数据
    input [63:0] ex_mult,
    input [63:0] ex_div,
    input [31:0] ex_clz,
    input [31:0] ex_alu,

    input [31:0] ex_pc_plus4,//imem地址pc
    //regfiles读数据
    input [31:0] ex_rs_data,
    input [31:0] ex_rt_data,
    //寄存器数据相关
    input [31:0] ex_cp0_data,
    input [31:0] ex_hi_data,
    input [31:0] ex_lo_data,

    input [4:0] ex_regfiles_waddr,//寄存器堆写入地址
    //寄存器写入使能
    input ex_w_regfiles,
    input ex_w_hi,
    input ex_w_lo,
    input ex_w_dmem,
    input ex_isGoto,
    //标志位
    input ex_sign,
    
    //多路选择器信号
    input [1:0] ex_dmemlength_choose,
    input [1:0] ex_hi_choose,
    input [1:0] ex_lo_choose,
    input [2:0] ex_rd_choose,//寄存器堆写入选择信号

    /*********MEM级数据**********/
    //运算部件数据
    output reg [63:0] mem_mult,
    output reg [63:0] mem_div,
    output reg [31:0] mem_clz,
    output reg [31:0] mem_alu,

    output reg [31:0] mem_pc_plus4,//imem地址pc
    //regfiles读数据
    output reg [31:0] mem_rs_data,
    output reg [31:0] mem_rt_data,
    //寄存器数据相关
    output reg [31:0] mem_cp0_data,
    output reg [31:0] mem_hi_data,
    output reg [31:0] mem_lo_data,

    output reg [4:0] mem_regfiles_waddr,//寄存器堆写入地址
    //寄存器写入使能
    output reg mem_w_regfiles,
    output reg mem_w_hi,
    output reg mem_w_lo,
    output reg mem_w_dmem,
    output reg mem_isGoto,
    //标志位
    output reg mem_sign,
    
    //多路选择器信号
    output reg [1:0] mem_dmemlength_choose,
    output reg [1:0] mem_hi_choose,
    output reg [1:0] mem_lo_choose,
    output reg [2:0] mem_rd_choose//寄存器堆写入选择信号
    );

    always @ (posedge clk or posedge rst)begin
        if(rst)begin
            mem_mult <= 64'b0;
            mem_div <= 64'b0;
            mem_clz <= 32'b0;
            mem_alu <= 32'b0;

            mem_pc_plus4 <= 32'b0;
    
            mem_rs_data <= 32'b0;
            mem_rt_data <= 32'b0;
    
            mem_cp0_data <= 32'b0;
            mem_hi_data <= 32'b0;
            mem_lo_data <= 32'b0;

            mem_regfiles_waddr <= 5'b0;
   
            mem_w_regfiles <= 1'b0;
            mem_w_hi <= 1'b0;
            mem_w_lo <= 1'b0;
            mem_w_dmem <= 1'b0;
            mem_isGoto <= 1'b0;
    
            mem_sign <= 1'b0;
    
            mem_dmemlength_choose <= 2'b0; 
            mem_hi_choose <= 2'b0;
            mem_lo_choose <= 2'b0;
            mem_rd_choose <= 3'b0;
        end

        else begin
            mem_mult <= ex_mult;
            mem_div <= ex_div;
            mem_clz <= ex_clz;
            mem_alu <= ex_alu;

            mem_pc_plus4 <= ex_pc_plus4;
    
            mem_rs_data <= ex_rs_data;
            mem_rt_data <= ex_rt_data;
    
            mem_cp0_data <= ex_cp0_data;
            mem_hi_data <= ex_hi_data;
            mem_lo_data <= ex_lo_data;

            mem_regfiles_waddr <= ex_regfiles_waddr;
   
            mem_w_regfiles <= ex_w_regfiles;
            mem_w_hi <= ex_w_hi;
            mem_w_lo <= ex_w_lo;
            mem_w_dmem <= ex_w_dmem;
            mem_isGoto <= ex_isGoto;
    
            mem_sign <= ex_sign;
    
            mem_dmemlength_choose <= ex_dmemlength_choose; 
            mem_hi_choose <= ex_hi_choose;
            mem_lo_choose <= ex_lo_choose;
            mem_rd_choose <= ex_rd_choose;
        end
    end
endmodule
