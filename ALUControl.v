`timescale 1ns/1ps
module ALUControl (
  input [2:0]ALUOp,
  input [5:0] in1,
  output reg [3:0] ALUcnt
  );
  
  always @(*) begin
    if (ALUOp==3'b000) begin
      if (in1==6'b000000) begin
        ALUcnt=4'b0000;
      end
      else if (in1==6'b000001) begin
        ALUcnt=4'b0001;
      end
      else if (in1==6'b000010) begin
        ALUcnt=4'b0101;
      end
      else if (in1==6'b000011) begin
        ALUcnt=4'b0110;
      end
      else if (in1==6'b000100) begin
        ALUcnt=4'b0111;
      end
      else if (in1==6'b000101) begin
        ALUcnt=4'b0011;
      end
      else if (in1==6'b000110) begin
          ALUcnt=4'b0100;
        
      end
      else if (in1==6'b000111) begin
       ALUcnt=4'b0010;
      end
    end
    else if (ALUOp==3'b001) begin
      ALUcnt=4'b0001;
    end
    else if (ALUOp==3'b010) begin
    ALUcnt=4'b0111;
    end
    else if (ALUOp==3'b011) begin
    ALUcnt=4'b0000;
    end
    
  end
  
endmodule