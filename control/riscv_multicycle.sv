`timescale 1ns / 100ps
`include "riscv_datapath_constants.sv"
`include "riscv_alu_constants.sv"

module riscv_multicycle #(parameter INITIAL_PC = 32'h00400000)
    (
    clk,
    rst,
    instruction,
    dReadData,
    PC, 
    dAddress,
    dWriteData,
    MemRead,
    MemWrite,
    WriteBackData
    );

    //define values
    input wire logic clk, rst;
    input wire logic [31:0] instruction, dReadData;
    output logic MemRead, MemWrite;
    output logic [31:0] PC, dAddress, dWriteData, WriteBackData;
    logic ALUSrc, MemtoReg, RegWrite, loadPC, PCSrc, Zero;
    logic [3:0] ALUCtrl;
    logic [6:0] opcode, funct7;
    logic [2:0] funct3;

    //instance the datapath file
     riscv_simple_datapath #INITIAL_PC datapathFile
     (
     .clk(clk), 
     .rst(rst), 
     .PCSrc(PCSrc), 
     .ALUSrc(ALUSrc), 
     .RegWrite(RegWrite), 
     .MemtoReg(MemtoReg), 
     .loadPC(loadPC), 
     .instruction(instruction), 
     .dReadData(dReadData), 
     .ALUCtrl(ALUCtrl), 
     .Zero(Zero), 
     .PC(PC), 
     .dAddress(dAddress), 
     .dWriteData(dWriteData), 
     .WriteBackData(WriteBackData)
     );
    
    //logic for the state machine - decide which part of the stage is required
    typedef enum logic[2:0] {IF, ID, EX, MEM, WB, ERR='X} State;
    State currentState, nextState;
    
        //state machine logic
    always_ff@(posedge clk)
        currentState <= nextState;

    //state machine determines the next stage of the cycle
    always_comb begin   
           nextState = ERR;         
           if(rst)
                nextState = IF;
           else          
           case(currentState)
                IF: 
                    nextState = ID;
                ID:
                    nextState = EX;   
                EX: 
                    nextState = MEM;   
                MEM:              
                    nextState = WB;   
                WB: 
                    nextState = IF; 
                default:
                    nextState = IF; 
           endcase        
    end
    
    //splits instruction to find opcode, funct3 and funct7 parts
    //some instructions do not contain funct3/funct7 - these are filtered about before
    assign opcode = {instruction[6:0]};
    assign funct3 = {instruction[14:12]};
    assign funct7 = {instruction[31:25]};
    
    //determine I/O values for the processor based on the instruction
    assign ALUSrc = ((opcode != rTYPE) && (opcode != bTYPE)) ? 1 : 0;
    assign MemRead = ((opcode == ilTYPE) && (currentState == MEM)) ? 1 : 0;
    assign MemWrite = ((opcode == sTYPE) && (currentState == MEM)) ? 1 : 0;
    assign MemtoReg = ((opcode == ilTYPE) && (currentState == WB)) ? 1 : 0;
    assign RegWrite = ((opcode != sTYPE) && (opcode != bTYPE) && (currentState == WB)) ? 1 : 0;
    assign loadPC = (currentState == WB) ? 1 : 0;
    assign PCSrc = (Zero && (opcode == bTYPE) && (currentState == WB)) ? 1 : 0;
    
    //ALU control - determines operation based on the instruction type and the funct3 value
    always_comb begin
    
        if((opcode == ilTYPE) || (opcode == sTYPE))                                             //load, store
            ALUCtrl = ALUOP_ADD;
        
        else if(opcode == bTYPE)                                                                //branching
            ALUCtrl = ALUOP_SUB;
        
        else if((opcode == rTYPE) || (opcode == iTYPE)) begin
        
            if(funct3 == FUNCT3_AND)                                                            //and/andi
                ALUCtrl = ALUOP_AND;                                                            //0000
                
            else if(funct3 == FUNCT3_OR)                                                        //or/ori
                ALUCtrl = ALUOP_OR;                                                             //0001
        
            else if((funct3 == FUNCT3_ADD) && ((funct7 == FUNCT7_ADD) || (opcode == iTYPE)))    //add/addi
                ALUCtrl = ALUOP_ADD;                                                            //0010
                
            else if((funct3 == FUNCT3_SUB) && (funct7 == FUNCT7_SUB) && (opcode == rTYPE))      //sub
                ALUCtrl = ALUOP_SUB;                                                            //0110                       
            
            else if(funct3 == FUNCT3_SLT)                                                       //less than/slti
                ALUCtrl = ALUOP_SLT;                                                            //0111
                
            else if((funct3 == FUNCT3_SRL) && (funct7 == FUNCT7_SRL))                           //shift right logical/srli
                ALUCtrl = ALUOP_SRL;                                                            //1000
                
            else if(funct3 == FUNCT3_SLL)                                                       //shift left logical/slli
                ALUCtrl = ALUOP_SLL;                                                            //1001
                
            else if((funct3 == FUNCT3_SRA) && (funct7 == FUNCT7_SRA))                           //sra/srai
                ALUCtrl = ALUOP_SRA;                                                            //1010                                      
            
            else if(funct3 == FUNCT3_XOR)                                                       //xor logic and xori
                ALUCtrl = ALUOP_XOR;                                                            //1101                                                                          
                
            else
                ALUCtrl = ALUOP_ADD;                                                        //default case
            end
            
        else
            ALUCtrl = ALUOP_ADD;                                                            //default case
    end         
         
endmodule