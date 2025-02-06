`timescale 1ns / 1ps

module IFIDReg(
	input [31:0]instruction,
	input [31:0]PCplusFour,
	input clk, hit,
	
	output reg [31:0] outInstruction,
	output reg [31:0] outNextPC
    );

	always@(posedge clk)
		begin
			if(hit !== 0) 
				begin
					outInstruction <= instruction;
					outNextPC <= PCplusFour;
				end
		end

endmodule