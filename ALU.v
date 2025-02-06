`timescale 1ns/1ps
module ALU (

  input [31:0]in1,
  input [31:0]in2,
  input [3:0] aluControl,
  input [4:0] shamt,
  output reg zero,
  output reg [31:0] out
  );
  
  always @( * ) begin
    if (aluControl==4'b0000) begin
      out=in1+in2;
    end
    else if (aluControl==4'b0001) begin
      out=in1-in2;
    end
    else if (aluControl==4'b0010) begin
      out=~in1;
    end
    else if (aluControl==4'b0011) begin
      out=in1<<shamt;
    end
    else if (aluControl==4'b0100) begin
      out=in1>>shamt;
    end
    else if (aluControl==4'b0101) begin
      out=in1&in2;
    end
    else if (aluControl==4'b0110) begin
      out=in1|in2;
    end
    else if (aluControl==4'b0111) begin
      if (in1<in2) begin
        out=1;
      end
      else begin
        out=0;
      end
    end




  end

always @(*) begin
  if (out==0) begin
    zero=1;
  end
  else begin
    zero=0;
  end
end
  
endmodule