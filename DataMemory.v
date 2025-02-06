`timescale 1ns/1ps

module DataMemory (
    input clk,
    input writeSig,
    input [31:0] address,
    input [31:0] inData,
    output reg [127:0] out
);

    reg [31:0] addressTemp;
    reg [7:0] memory [1024:0];
    reg [2:0] clock=0;

    always @(negedge clk) begin
        if (writeSig) begin
            memory[address]=inData[31:24];
            memory[address+1]=inData[23:16];
            memory[address+2]=inData[15:8];
            memory[address+3]=inData[7:0];
        end
    end

    always @(posedge clk) begin
        addressTemp=address;
        clock=clock+1;
        if (clock==5) begin
            addressTemp[3:0]=0;
            out={memory[addressTemp],memory[addressTemp+1],memory[addressTemp+2],memory[addressTemp+3],memory[addressTemp+4],memory[addressTemp+5],memory[addressTemp+6],memory[addressTemp+7],memory[addressTemp+8],memory[addressTemp+9],memory[addressTemp+10],memory[addressTemp+11],memory[addressTemp+12],memory[addressTemp+13],memory[addressTemp+14],memory[addressTemp+15]};
        end
    end

    always @(address) begin
        clock=0;
    end

endmodule