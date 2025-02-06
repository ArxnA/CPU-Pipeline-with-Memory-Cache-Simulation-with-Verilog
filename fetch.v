// `timescale 1ns / 1ps
// `include "InstructionMemory.v"
// `include "PC.v"
// `include "Mux.v"
// module fetch (
//   input clk,
//   input sel,
//   input [31:0] in,
//   output reg [31:0] out,
//   output reg [31:0] pc_plus_four  // added output for tmp
// );
//   wire [31:0] muxpc;
//   wire [31:0] pcim;
//   wire [31:0] temp;
//   assign temp = pcim + 4;

//   // Mux to select between temp and input in
//   Mux mux1(
//     .in1(temp),
//     .in2(in),
//     .sel(sel),
//     .out(muxpc)
//   );

//   // PC to hold the address of the next instruction
//   PC pc1(
//     .clk(clk),
//     .in(muxpc),
//     .out(pcim)
//   );

//   // Instruction memory to fetch the instruction
//   InstructionMemory IM1(
//     .clk(clk),
//     .in(pcim),
//     .out(out)
//   );

//   // Capture temp into tmp_out on every clock cycle
//   always @(*) begin
//     pc_plus_four <= temp;  // Register temp value to tmp_out
//   end
// endmodule
`timescale 1ns / 1ps
`include "InstructionMemory.v"
`include "PC.v"
`include "Mux.v"
module fetch (
  input clk,
  input sel,
  input [31:0] in,
  input hit,
  output wire [31:0] out,           // Change to wire
  output reg [31:0] pc_plus_four   // Keep as reg for procedural assignment
);
  wire [31:0] muxpc;
  wire [31:0] pcim;
  wire [31:0] temp;
  assign temp = pcim + 4;

  // Mux to select between temp and input in
  Mux mux1(
    .in1(temp),
    .in2(in),
    .sel(sel),
    .out(muxpc)
  );

  // PC to hold the address of the next instruction
  PC pc1(
    .clk(clk),
    .in(muxpc),
    .out(pcim),
    .hit(hit)
  );

  // Instruction memory to fetch the instruction
  InstructionMemory IM1(
    .clk(clk),
    .in(pcim),
    .out(out)  // out is now a wire
  );

  // Capture temp into pc_plus_four on every clock cycle
  always @(*) begin
    pc_plus_four <= temp;  // Register temp value to pc_plus_four
  end
endmodule
