`timescale 1ns / 1ps

module riscv_alu(

    //define inputs and outputs
    input [31:0] op1,
    input [31:0] op2,
    input [3:0] alu_op,
    output zero,
    output reg [31:0] result
    
    );
    
    //separate header file with constants
    `include "riscv_alu_constants.sv"
    
    //combinational logic
    always_comb
    begin
        case (alu_op)                                                   //case statement for each of the available functions
            4'b0000 : result = op1 & op2;                               //AND
            4'b0001 : result = op1 | op2;                               //OR
            4'b0010 : result = op1 + op2;                               //Add
            4'b0110 : result = op1 - op2;                               //Subtract
            4'b0111 : result = $signed(op1) < $signed(op2);             //Less Than
            4'b1000 : result = op1 >> op2[4:0];                         //Shift Right (Logical)
            4'b1001 : result = op1 << op2[4:0];                         //Shift Left (Logical)
            4'b1010 : result = $unsigned($signed(op1) >>> op2[4:0]);    //Shift Right (Arithmetic)
            4'b1101 : result = op1 ^ op2;                               //XOR
        endcase
    end
    
endmodule
