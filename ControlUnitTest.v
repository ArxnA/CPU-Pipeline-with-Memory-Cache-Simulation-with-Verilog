`timescale  1ns / 1ps
`include "ControlUnit.v"

module ControlUnitTest;

// ControlUnit Inputs
reg   [5:0]  opCode                        = 0 ;

// ControlUnit Outputs
wire  regDst                               ;
wire  aluSrc                               ;
wire  memToReg                             ;
wire  regWrite                             ;
wire  memRead                              ;
wire  memWrite                             ;
wire  branch                               ;
wire  [2:0]  aluOp                         ;



ControlUnit  u_ControlUnit (
    .opCode                  ( opCode    [5:0] ),

    .regDst                  ( regDst          ),
    .aluSrc                  ( aluSrc          ),
    .memToReg                ( memToReg        ),
    .regWrite                ( regWrite        ),
    .memRead                 ( memRead         ),
    .memWrite                ( memWrite        ),
    .branch                  ( branch          ),
    .aluOp                   ( aluOp     [2:0] )
);

initial
begin
    $dumpfile("ControlUnit.vcd");
    $dumpvars(0,ControlUnitTest);
end

initial
begin
    opCode=6'b000000;
    #200
    opCode=6'b000100;
    #200
    opCode=6'b000101;
    #200
    opCode=6'b000111;
    #200
    opCode=6'b000110;
    #200
    opCode=6'b000001;
    #200
    $finish;
end

endmodule