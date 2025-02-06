`timescale 1ns/1ps
module Mux (
  input [31:0]in1,
  input [31:0]in2,
  input sel,
  output [31:0] out
);
  assign out= sel ? in2: in1;

  // always @(*) begin
  //  if (sel) begin
  //   out=in2;
  //  end else begin 
  //   out=in1;
  //  end
  // end


endmodule