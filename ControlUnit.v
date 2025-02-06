`timescale 1ns / 1ps

module ControlUnit(
    input [5:0] opCode,
    output reg regDst,
    output reg aluSrc,
    output reg memToReg,
    output reg regWrite,
    output reg memRead,
    output reg memWrite,
    output reg branch,
    output reg [2:0] aluOp
    );

    initial begin
        regDst = 0;
        aluSrc = 0;
        memToReg = 0;
        regWrite = 0;
        memRead = 0;
        memWrite = 0;
        branch = 0;
        aluOp = 3'b000;
    end
    
    always @ (opCode) begin

        if (opCode == 6'b000000) begin                                      // R-type
            regDst = 1;
            aluSrc = 0;
            memToReg = 0;
            regWrite = 1;
            memRead = 0;
            memWrite = 0;
            branch = 0;
            aluOp = 3'b000;
        end
        if (opCode == 6'b000100) begin                                      // lw
            regDst = 0;
            aluSrc = 1;
            memToReg = 1;
            regWrite = 1;
            memRead = 1;
            memWrite = 0;
            branch = 0;
            aluOp = 3'b011;
        end
        if (opCode == 6'b000101) begin                                      // sw
            regDst = 0;
            aluSrc = 1;
            memToReg = 0;
            regWrite = 0;
            memRead = 0;
            memWrite = 1;
            branch = 0;
            aluOp = 3'b011;
        end
        if (opCode == 6'b000111) begin                                  // addi
            regDst = 0;
            aluSrc = 1;
            memToReg = 0;
            regWrite = 1;
            memRead = 0;
            memWrite = 0;
            branch = 0;
            aluOp = 3'b011;
        end
        if (opCode == 6'b000110) begin                                  // beq
            regDst = 0;
            aluSrc = 0;
            memToReg = 0;
            regWrite = 0;
            memRead = 0;
            memWrite = 0;
            branch = 1;
            aluOp = 3'b001;
        end
        if (opCode == 6'b000001) begin                                  // slti
            regDst = 0;
            aluSrc = 1;
            memToReg = 0;
            regWrite = 1;
            memRead = 0;
            memWrite = 0;
            branch = 0;
            aluOp = 3'b010;
        end
    end
    
endmodule