`timescale  1ns / 1ps  
`include "CPU2.v"

module CPU2_tb;


// CPU Inputs
reg   clk                                  = 0 ;

// CPU Outputs



initial begin
    $dumpfile("CPU2.vcd");
    $dumpvars(0,CPU2_tb);
end

CPU  u_CPU (
    .clk                     ( clk   )
);

initial
begin
    clk = 0;
    #2000

    $finish;
end

always #10 clk = ~clk;

endmodule