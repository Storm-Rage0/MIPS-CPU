`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/08 15:18:07
// Design Name: 
// Module Name: MUX_8to1
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


module MUX_8to1(
    input [31:0] a1,
    input [31:0] a2,
    input [31:0] a3,
    input [31:0] a4,
    input [31:0] a5,
    input [31:0] a6,
    input [31:0] a7,
    input [31:0] a8,
    
    input [2:0] choose,
    output reg [31:0] z
    );

    always @ (*) begin
        case(choose)
            3'b000:z<=a1;
            3'b001:z<=a2;
            3'b010:z<=a3;
            3'b011:z<=a4;
            3'b100:z<=a5;
            3'b101:z<=a6;
            3'b110:z<=a7;
            3'b111:z<=a8;
            
            default: z<=32'bx;
        endcase
    end

endmodule
