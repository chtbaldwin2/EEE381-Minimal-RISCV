`timescale 1ns / 1ps

module regfile
    (
    clk, 
    readReg1, 
    readReg2, 
    writeReg, 
    writeData, 
    write, 
    readData1, 
    readData2
    );

    //define values
    input wire logic clk;
    input wire logic [4:0] readReg1, readReg2, writeReg;
    input wire logic [31:0] writeData;
    input wire logic write;   
    output logic [31:0] readData1, readData2;
            
    // Define an array used for the register (32x32)
    logic [31:0] register[31:0];
    
    //Initialise register
    integer i;
    initial
      for (i=0;i<32;i=i+1)
        register[i] = 0;
        
    //Reads to the given registers then writes to the disired one.    
    always_ff@(posedge clk) begin
    
        readData1 <= register[readReg1];
        readData2 <= register[readReg2];
        
        if (write && (writeReg!=0)) begin
        
            register[writeReg] <= writeData;
          
            if (readReg1 == writeReg)
                readData1 <= writeData;
            if (readReg2 == writeReg)
                readData2 <= writeData;
           
        end
        
     end
       
endmodule