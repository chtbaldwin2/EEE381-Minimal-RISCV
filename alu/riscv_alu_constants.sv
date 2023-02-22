`timescale 1ns / 1ps

module riscv_alu_constants(
    );
    
    //parameters used in the ALU to indicate function
    //called upon by other parts of the CPU
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