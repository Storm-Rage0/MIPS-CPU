`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/11 17:29:03
// Design Name: 
// Module Name: ConfirmBranch
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


module ConfirmBranch(
    input [31:0] rs_data,
    input [31:0] rt_data,
    input [1:0] branch_ena,
    output reg is_branch
    );

    always @ (*)begin
        case (branch_ena) 
            2'b00:begin//beq
                if(rs_data == rt_data) is_branch <= 1'b1;
                else is_branch <= 1'b0;
            end
            2'b01:begin//bne
                if(rs_data != rt_data) is_branch <= 1'b1;
                else is_branch <= 1'b0;
            end
            2'b10:begin//bgez
                if(rs_data > 32'b0) is_branch <= 1'b1;
                else is_branch <= 1'b0;
            end
            2'b11:begin//teq
                if(rs_data == rt_data) is_branch <= 1'b1;
                else is_branch <= 1'b0;
            end
            default: is_branch <= 1'bx;

        endcase
    end

endmodule
