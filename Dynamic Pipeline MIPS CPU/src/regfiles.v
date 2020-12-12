`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/07 17:43:48
// Design Name: 
// Module Name: regfile
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

module regfiles(
    input clk, //�½���д������
    input rst, //reset�첽��λ����Ч
    input we, //�Ĵ�����д��Ч�źţ��ߵ�ƽʱ����Ĵ���д������
    input [4:0] raddr1, 
    input [4:0] raddr2, 
    input [4:0] waddr, //д���ַ
    input [31:0] wdata, //д������
    output [31:0] rdata1, 
    output [31:0] rdata2   
    );

    reg [31:0] array_reg[0:31];

    //��ʼ��
    integer i;
    initial begin
        for(i = 0; i < 32; i = i +1) begin
            array_reg[i] <= 32'b0;
        end
    end

    assign rdata1 = raddr1 == waddr ? wdata : array_reg[raddr1];
    assign rdata2 = raddr2 == waddr ? wdata : array_reg[raddr2];
    
    //д����
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            for(i = 0;i < 32;i = i + 1)
                array_reg[i] <= 0;
        end
        else 
        begin
            if(waddr != 5'b0 && we == 1)
                array_reg[waddr] <= wdata;
        end
    end

endmodule
