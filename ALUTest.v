`timescale  1ns / 1ps
`include "ALU.v"

module ALUTest;       


// ALU Inputs
reg   [31:0]  in1                          = 0 ;
reg   [31:0]  in2                          = 0 ;
reg   [3:0]  aluControl                    = 0 ;
reg   [4:0]  shamt                         = 0 ;

// ALU Outputs
wire  zero                                 ;
wire  [31:0]  out                          ;


ALU  u_ALU (
    .in1                     ( in1         [31:0] ),
    .in2                     ( in2         [31:0] ),
    .aluControl              ( aluControl  [3:0]  ),
    .shamt                   ( shamt       [4:0]  ),

    .zero                    ( zero               ),
    .out                     ( out         [31:0] )
);

initial
begin
    $dumpfile("ALU.vcd");
    $dumpvars(0,ALUTest);
end


initial
begin
    in1=4;
    in2=2;
    shamt=2;
    aluControl=4'b0000;
    #200
    aluControl=4'b0001;
    #200
    aluControl=4'b0010;
    #200
    aluControl=4'b0011;
    #200
    aluControl=4'b0100;
    #200
    aluControl=4'b0101;
    #200
    aluControl=4'b0110;
    #200
    aluControl=4'b0111;
    #200
    in1=2;
    in2=2;
    aluControl=4'b0001;
    #200
    $finish;
end

endmodule