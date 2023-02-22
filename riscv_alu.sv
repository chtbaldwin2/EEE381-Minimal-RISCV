`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.02.2023 11:57:18
// Design Name: 
// Module Name: alu
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


module riscv_alu(

    input [31:0] op1,
    input [31:0] op2,
    input [3:0] alu_op,
    output zero,
    output reg [31:0] result
    
    );
    
    `include "riscv_alu_constants.sv"
    
    always_comb
    begin
        case (alu_op)
            4'b0000 : result = op1 & op2;
            4'b0001 : result = op1 | op2;
            4'b0010 : result = op1 + op2;
            4'b0110 : result = op1 - op2;
            4'b0111 : result = $signed(op1) < $signed(op2);
            4'b1000 : result = op1 >> op2[4:0];
            4'b1001 : result = op1 << op2[4:0];
            4'b1010 : result = $unsigned($signed(op1) >>> op2[4:0]);
            4'b1101 : result = op1 ^ op2;
        endcase
    end
    
endmodule
