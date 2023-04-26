`ifndef RISCV_DATAPATH_CONSTANTS
`define RISCV_DATAPATH_CONSTANTS

localparam[6:0] rTYPE = 7'b0110011; 
localparam[6:0] iTYPE = 7'b0010011;
localparam[6:0] ilTYPE = 7'b0000011;  
localparam[6:0] sTYPE = 7'b0100011; 
localparam[6:0] bTYPE = 7'b1100011; 
localparam[2:0] FUNCT3_OR = 3'b110;
localparam[2:0] FUNCT3_SLT = 3'b010;
localparam[2:0] FUNCT3_XOR = 3'b100;
localparam[2:0] FUNCT3_AND = 3'b111;
localparam[2:0] FUNCT3_SUB = 3'b000;
localparam[2:0] FUNCT3_ADD = 3'b000;
localparam[2:0] FUNCT3_SLL = 3'b001;
localparam[2:0] FUNCT3_SRL = 3'b101;
localparam[2:0] FUNCT3_SRA = 3'b101;
localparam[6:0] FUNCT7_SUB = 7'b0100000;
localparam[6:0] FUNCT7_ADD = 7'b0000000;
localparam[6:0] FUNCT7_SRL = 7'b0100000;
localparam[6:0] FUNCT7_SRA = 7'b0000000;

`endif
