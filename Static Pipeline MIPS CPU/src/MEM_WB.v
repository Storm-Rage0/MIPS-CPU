`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/16 12:50:46
// Design Name: 
// Module Name: MEM_WB
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
MEM/WB�м䲿��������Ĵ���д����������ơ�ѡ���ź�
***************************************/

module MEM_WB(
    input clk,
    input rst,
    /*********MEM������**********/
    //���㲿������
    input [63:0] mem_mult,
    input [63:0] mem_div,
    input [31:0] mem_clz,
    input [31:0] mem_alu,
    //DMEM����
    input [31:0] mem_dmem_odata,

    input [31:0] mem_pc_plus4,//imem��ַpc
    //regfiles������
    input [31:0] mem_rs_data,
    input [31:0] mem_rt_data,
    //�Ĵ����������
    input [31:0] mem_cp0_data,
    input [31:0] mem_hi_data,
    input [31:0] mem_lo_data,

    input [4:0] mem_regfiles_waddr,//�Ĵ�����д���ַ
    //�Ĵ���д��ʹ��
    input mem_w_regfiles,
    input mem_w_hi,
    input mem_w_lo,

    //��·ѡ�����ź�
    input [1:0] mem_hi_choose,
    input [1:0] mem_lo_choose,
    input [2:0] mem_rd_choose,//�Ĵ�����д��ѡ���ź�

    /********WB������********/
    output reg [63:0] wb_mult,
    output reg [63:0] wb_div,
    output reg [31:0] wb_clz,
    output reg [31:0] wb_alu,
    //DMEM����
    output reg [31:0] wb_dmem_odata,

    output reg [31:0] wb_pc_plus4,//imem��ַpc
    //regfiles������
    output reg [31:0] wb_rs_data,
    output reg [31:0] wb_rt_data,
    //�Ĵ����������
    output reg [31:0] wb_cp0_data,
    output reg [31:0] wb_hi_data,
    output reg [31:0] wb_lo_data,

    output reg [4:0] wb_regfiles_waddr,//�Ĵ�����д���ַ
    //�Ĵ���д��ʹ��
    output reg wb_w_regfiles,
    output reg wb_w_hi,
    output reg wb_w_lo,

    //��·ѡ�����ź�
    output reg [1:0] wb_hi_choose,
    output reg [1:0] wb_lo_choose,
    output reg [2:0] wb_rd_choose//�Ĵ�����д��ѡ���ź�
    );

    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            wb_mult <= 64'b0;
            wb_div <= 64'b0;
            wb_clz <= 32'b0;
            wb_alu <= 32'b0;

            wb_dmem_odata <= 32'b0; 

            wb_pc_plus4 <= 32'b0;

            wb_rs_data <= 32'b0;
            wb_rt_data <= 32'b0;

            wb_cp0_data <= 32'b0;
            wb_hi_data <= 32'b0;
            wb_lo_data <= 32'b0;

            wb_regfiles_waddr <= 5'b0; 

            wb_w_regfiles <= 1'b0;
            wb_w_hi <= 1'b0;
            wb_w_lo <= 1'b0;

            wb_hi_choose <= 2'b0;
            wb_lo_choose <= 2'b0;
            wb_rd_choose <= 3'b0;
        end
        else begin
            wb_mult <= mem_mult;
            wb_div <= mem_div;
            wb_clz <= mem_clz;
            wb_alu <= mem_alu;

            wb_dmem_odata <= mem_dmem_odata;

            wb_pc_plus4 <= mem_pc_plus4;

            wb_rs_data <= mem_rs_data;
            wb_rt_data <= mem_rt_data;

            wb_cp0_data <= mem_cp0_data;
            wb_hi_data <= mem_hi_data;
            wb_lo_data <= mem_lo_data;

            wb_regfiles_waddr <= mem_regfiles_waddr;

            wb_w_regfiles <= mem_w_regfiles;
            wb_w_hi <= mem_w_hi;
            wb_w_lo <= mem_w_lo;

            wb_hi_choose <= mem_hi_choose;
            wb_lo_choose <= mem_lo_choose;
            wb_rd_choose <= mem_rd_choose;
        end
    end
endmodule
