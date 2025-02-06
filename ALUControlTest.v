`timescale  1ns / 1ps
`include "ALUControl.v"


module ALUControlTest;



// aluControl Inputs
reg   [5:0]  in1                           = 0 ;
reg   [2:0]  ALUOp                         = 0 ;

// aluControl Outputs
wire  [3:0]  ALUcnt                        ;



ALUControl  u_ALUControl (
    .in1                     ( in1     [5:0] ),
    .ALUOp                   ( ALUOp   [2:0] ),

    .ALUcnt                  ( ALUcnt  [3:0] )
);

initial
begin
    $dumpfile("ALUControl.vcd");
    $dumpvars(0,ALUControlTest);
end

initial
begin

    ALUOp = 3'b000;
    in1 = 6'b000000;
    #200
    in1 = 6'b000001;
    #200
    in1 = 6'b000010;
    #200
    in1 = 6'b000011;
    #200
    in1 = 6'b000100;
    #200
    in1 = 6'b000101;
    #200
    in1 = 6'b000110;
    #200
    in1 = 6'b000111;
    #200
    ALUOp = 3'b001;
    #200
    ALUOp = 3'b010;
    #200
    ALUOp = 3'b011;
    #200

    $finish;
end

endmodule