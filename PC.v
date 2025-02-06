`timescale 1ns/1ps
module PC (
  input clk,
  input [31:0] in,
  input hit,
  output reg [31:0] out

);

integer i;
initial begin
  out = 0;
  i = 0;

end

always @(posedge clk ) begin
  if (i > 3) begin
   if (in === 32'bx || in === 32'bz) begin
    out = 32'b0;
   end 
    if (hit === 1) begin
    out = in;
  end
  end
  else 
  begin
    i= i+1;
    out = out + 4;
  end
end

endmodule