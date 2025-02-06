`timescale  1ns / 1ps
`include "DataMemory.v"

module DataMemoryTest;   


// DataMemory Inputs
reg   clk                                  = 0 ;
reg   writeSig                             = 0 ;
reg   [31:0]  address                      = 0 ;
reg   [31:0]  inData                       = 0 ;

// DataMemory Outputs
wire  [127:0]  out                         ;


DataMemory  u_DataMemory (
    .clk                     ( clk               ),
    .writeSig                ( writeSig          ),
    .address                 ( address   [31:0]  ),
    .inData                  ( inData    [31:0]  ),

    .out                     ( out       [127:0] )
);

initial
begin
    $dumpfile("DM.vcd");
    $dumpvars(0,DataMemoryTest);
end

initial
begin

    address=0;
    writeSig=1;
    inData=7;
    #200
    address=20;
    writeSig=1;
    inData=15;
    #200
    writeSig=0;
    address=5;
    #100
    address=17;
    #800

    $finish;
end
always #50 clk=~clk;

endmodule