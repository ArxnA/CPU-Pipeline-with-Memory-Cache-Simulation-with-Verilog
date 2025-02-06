`timescale  1ns / 1ps  
`include "RegisterFile.v"   

module RFTest;   


// RegisterFile Inputs
reg   clk                                  = 0 ;
reg   RegWrite                             = 0 ;
reg   [4:0]  rs                            = 0 ;
reg   [4:0]  rt                            = 0 ;
reg   [4:0]  rd                            = 0 ;
reg   [31:0]  in                           = 0 ;

// RegisterFile Outputs
wire  [31:0]  out1                         ;
wire  [31:0]  out2                         ;



RegisterFile  u_RegisterFile (
    .clk                     ( clk              ),
    .RegWrite                ( RegWrite         ),
    .rs                      ( rs        [4:0]  ),
    .rt                      ( rt        [4:0]  ),
    .rd                      ( rd        [4:0]  ),
    .in                      ( in        [31:0] ),

    .out1                    ( out1      [31:0] ),
    .out2                    ( out2      [31:0] )
);
initial
begin
    $dumpfile("RegisterFile.vcd");
    $dumpvars(0,RFTest);
end

initial
begin

    clk=0;
    RegWrite=0;
    rs=5;
    rt=7;
    rd=4;
    in=2;
    #200
    RegWrite=1;
    rs=5;
    rt=7;
    rd=4;
    in=9;
    #200
    RegWrite=0;
    rs=4;
    rt=7;
    rd=6;
    in=9;
    #200

    $finish;
end
always #50 clk = ~clk;

endmodule