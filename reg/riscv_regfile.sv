`timescale 1ns / 1ps

//register file for RISC-V CPU
module riscv_regfile(

        //define inputs and outputs
        input clk,
        input [4:0] readReg1,
        input [4:0] readReg2,
        input [4:0] writeReg,
        input [31:0] writeData,
        input write,
        output reg [31:0] readData1,
        output reg [31:0] readData2

    );
    
    //create register to store data
    //32 bit register - RV32I
    logic [31:0] register[31:0];
    
    //fill register with all zeros - ready for data to be loaded in
    integer i;
    initial
        for (i=0; i<32; i=i+1)
            register[i] = 0;
    
    //Able to read two registers and write to one in a single clock cycle
    //multi-ported memory
    always_ff@(posedge clk) begin
    
        readData1 <= register[readReg1];        //read data from reg1
        readData2 <= register[readReg2];        //read data from reg2
        
        if ((write) && (writeReg!=0)) begin     //ensure that the CPU is ready to write
                                                //and the register being written to isn't x0
            register[writeReg] <= writeData;    //write data into the register
            
            if (readReg1 == writeReg)           //data is updated
                readData1 <= writeData;
            if (readReg2 == writeReg)           
                readData2 <= writeData;
                
        end
    end
    
endmodule
