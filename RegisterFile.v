`timescale  1ns / 1ps
module RegisterFile (
  input clk,
  input RegWrite,
  input [4:0] rs,
  input [4:0]rt,
  input [4:0] rd,
  input [31:0] in,
  output reg [31:0] out1,
  output reg [31:0] out2
);
 reg [31:0] registers [31:0];

always @(posedge clk ) begin

    out1<=registers[rs];
    out2<=registers[rt];
    

  end
  always @(negedge clk ) begin

    if (RegWrite) begin
      registers[rd]=in;
    end

  end

  integer i;
  initial begin
    for ( i=0 ; i<32; i=i+1) begin
      registers[i]=i;
    end
  end
  
endmodule