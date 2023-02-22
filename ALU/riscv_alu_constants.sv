`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.02.2023 12:42:00
// Design Name: 
// Module Name: riscv_alu_constants
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


module riscv_alu_constants(
    );
    
    localparam[3:0] ALUOP_AND = 4'b0000;
    localparam[3:0] ALUOP_OR = 4'b0001;
    localparam[3:0] ALUOP_ADD = 4'b0010;
    localparam[3:0] ALUOP_SUB = 4'b0110;
    localparam[3:0] ALUOP_LT = 4'b0111;
    localparam[3:0] ALUOP_SRL = 4'b1000;
    localparam[3:0] ALUOP_SLL = 4'b1001;
    localparam[3:0] ALUOP_SRA = 4'b1010;
    localparam[3:0] ALUOP_XOR = 4'b1101;
    
endmodule
