`timescale  1ns / 1ps
`include "Cache.v"

module CacheTest;

// Cache Inputs
reg   clk                                  = 0 ;
reg   [31:0]  address                      = 0 ;
reg   [127:0]  inData                      = 0 ;

// Cache Outputs
wire  [31:0]  out                          ;
wire  hit                                  ;


Cache  u_Cache (
    .clk                     ( clk              ),
    .address                 ( address  [31:0]  ),
    .inData                  ( inData   [127:0] ),

    .out                     ( out      [31:0]  ),
    .hit                     ( hit              )
);

initial
begin
    $dumpfile("Cache.vcd");
    $dumpvars(0,CacheTest);
end

initial
begin
    clk=0;
    address=0;
    inData=5;
    #200
    address=100;
    #200
    $finish;
end

always #50 clk=~clk;

endmodule