`timescale 1ns/1ps
module InstructionMemory (
  input clk,
  input [31:0] in,
  output reg [31:0] out
);

  initial $readmemb("input.txt", memory, 0, 49);
  reg [7:0] memory [49:0];

  always @(posedge clk ) begin

    out={memory[in],memory[in+1],memory[in+2],memory[in+3]};

  end


endmodule