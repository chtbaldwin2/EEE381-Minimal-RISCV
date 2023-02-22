`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.02.2023 13:20:20
// Design Name: 
// Module Name: riscv_regfile
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


module riscv_regfile(

        input clk,
        input [4:0] readReg1,
        input [4:0] readReg2,
        input [4:0] writeReg,
        input [31:0] writeData,
        input write,
        output reg [31:0] readData1,
        output reg [31:0] readData2

    );
    
    logic [31:0] register[31:0];
    
    integer i;
    initial
        for (i=0; i<32; i=i+1)
            register[i] = 0;
    
    always_ff@(posedge clk) begin
        readData1 <= register[readReg1];
        readData2 <= register[readReg2];
        if ((write) && (writeReg!=0)) begin
            register[writeReg] <= writeData;
            if (readReg1 == writeReg)
                readData1 <= writeData;
            if (readReg2 == writeReg)
                readData2 <= writeData;
        end
    end
    
endmodule
