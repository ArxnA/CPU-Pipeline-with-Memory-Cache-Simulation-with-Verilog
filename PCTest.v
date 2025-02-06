`timescale  1ns / 1ps  
`include "PC.v"

module PCTest;


// PC Inputs
reg   clk                                  = 0 ;
reg   [31:0]  in                           = 0 ;

// PC Outputs
wire  [31:0]  out                          ;



PC  u_PC (
    .clk                     ( clk         ),
    .in                      ( in   [31:0] ),

    .out                     ( out  [31:0] )
);

initial begin
    $dumpfile("PC.vcd");
    $dumpvars(0,PCTest);
end

initial
begin
    clk = 0;
    in=1;
    #100
    in=111111;
    #500

    $finish;
end

always #100 clk = ~clk;

endmodule