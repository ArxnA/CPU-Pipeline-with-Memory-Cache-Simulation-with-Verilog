`timescale  1ns / 1ps
`include "InstructionMemory.v"
module IMTest; 


// InstructionMemory Inputs
reg   clk                                  = 0 ;
reg   [31:0]  in                           = 0 ;

// InstructionMemory Outputs
wire  [31:0]  out                          ;


InstructionMemory  u_InstructionMemory (
    .clk                     ( clk         ),
    .in                      ( in   [31:0] ),

    .out                     ( out  [31:0] )
);

initial
begin
    $dumpfile("IM.vcd");
    $dumpvars(0,IMTest);
end

initial
begin
    clk=0;
    in=5;
    #100
    in=10;
    #100
    in=20;
    #200
    $finish;
end
always #50 clk = ~clk;

endmodule