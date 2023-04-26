`timescale 1ns / 100ps
`include "riscv_datapath_constants.sv"

module riscv_simple_datapath #(parameter INITIAL_PC = 32'h00400000)
    (
    clk, 
    rst, 
    PCSrc, 
    ALUSrc, 
    RegWrite, 
    MemtoReg, 
    loadPC, 
    instruction, 
    dReadData, 
    ALUCtrl, 
    Zero, 
    PC, 
    dAddress, 
    dWriteData, 
    WriteBackData
    );
    
    //define values
    input wire logic clk, rst, PCSrc, ALUSrc, RegWrite, MemtoReg, loadPC;
    input wire logic [31:0] instruction, dReadData;
    input wire logic [3:0] ALUCtrl;
    output logic Zero;
    output logic [31:0] PC, dAddress, dWriteData, WriteBackData;   
    logic [31:0] ReadData1, ReadData2, instruction_ext, ALUresult, op2, s_type_immediate, branch_offset;
    
    //assign instructions to the specified instruction type
    assign s_type_immediate = {{20 {instruction[31]}}, instruction[31:25], instruction[11:7]};                                      //S-Type Immediate
    assign instruction_ext = {{20 {instruction[31]}}, instruction[31:20]};                                                          //Sign Extended Immediate
    assign branch_offset = {{19 {instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};  //Branch Offset
    assign funct3 = instruction[14:12];

    // Instance ALU file
    alu aluFile
        (
        .op1(ReadData1),
        .op2(op2), 
        .alu_op(ALUCtrl), 
        .zero(Zero), 
        .result(ALUresult)
        );
        
    // Instance register file
    regfile registerFile
        (
        .clk(clk),
        .readReg1(instruction[19:15]), 
        .readReg2(instruction[24:20]),
        .writeReg(instruction[11:7]),
        .writeData(WriteBackData), 
        .write(RegWrite),
        .readData1(ReadData1),
        .readData2(ReadData2)
        );

    //Program Counter Logic
    always_ff@(posedge clk) begin
        if(rst)
            //reset puts PC back to the initial value defined
            PC <= INITIAL_PC;
        if(loadPC & PCSrc & Zero)
            //branch offset - used when a branching instruction is used
            PC <= PC + branch_offset;
        else if(loadPC)
            //Program Counter increments as standard
            PC <= PC + 4;
        end
        
    //Checks instruction type and assigns op2 to different values depending on instruction type  
    always_comb
        if(ALUSrc)
            if(instruction[6:0] == sTYPE)
                op2 <= s_type_immediate;    
            else
                op2 <= instruction_ext;
        else   
            op2 <= ReadData2;

    //Logic for WriteBack
    assign dWriteData = ReadData2;
    assign dAddress = ALUresult;
    
    always_comb
        if(MemtoReg)
            WriteBackData <= dReadData;
        else
            WriteBackData <= ALUresult;

endmodule
