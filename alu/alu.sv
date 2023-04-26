`timescale 1 ns / 1 ps 
`include "riscv_alu_constants.sv"

module alu
    (
    op1, 
    op2, 
    alu_op, 
    zero, 
    result
    );

    //define inputs
    input wire logic signed [31:0] op1, op2;
    input wire logic signed [3:0] alu_op;
    output logic zero;
    output logic signed [31:0] result;

    //assign zero value
    assign zero = (result == 0);
    
    //mux that determines what mathematical operation to provide
    always_comb begin
    
        case(alu_op)
            ALUOP_AND: result = op1 & op2;                              //AND logic
            ALUOP_OR: result = op1 | op2;                               //OR logic
            ALUOP_ADD: result = op1 + op2;                              //Addition
            ALUOP_SUB: result = op1 - op2;                              //Subtraction
            ALUOP_LES: result = $signed(op1) < $signed(op2);            //Less Than
            ALUOP_SRL: result = op1 >> op2[4:0];                        //Shift Right Logical
            ALUOP_SLL: result = op1 << op2[4:0];                        //Shift Left Logical
            ALUOP_SRA: result = $unsigned($signed(op1) >>> op2[4:0]);   //Shift Right Arithmetic
            ALUOP_XOR: result = op1 ^ op2;                              //XOR logic
            default: result = op1 + op2;                                //default value (addition)       
        endcase
        
        //display the values - used for testing
        $display("op1 = %d, op2 = %d, alu_op = %b, result = %d", op1, op2, alu_op, result);
        
    end
    
endmodule
