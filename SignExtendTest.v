`timescale  1ns / 1ps
`include "SignExtend.v"

module SignExtendTest;

// SignExtend Inputs
reg   [15:0]  in                           = 0 ;

// SignExtend Outputs
wire  [31:0]  out                          ;

SignExtend  u_SignExtend (
    .in                      ( in   [15:0] ),

    .out                     ( out  [31:0] )
);

initial
begin
    $dumpfile("SignExtend.vcd");
    $dumpvars(0,SignExtendTest);
end

initial
begin
  in=16'b0000000000000001;
  #200
  in=16'b1111111111111111;
  #200
    $finish;
end

endmodule