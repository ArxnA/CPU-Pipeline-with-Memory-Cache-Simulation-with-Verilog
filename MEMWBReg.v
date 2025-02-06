`timescale 1ns / 1ps

module MEMWBReg(
		input [31:0]ALUout, MemoryOut,
		input [4:0]writeReg,
		input [1:0]controlSig,
		input clk, hit,
		
		output reg [31:0] outALUot, outMemoryOut,
		output reg [4:0] outWriteReg,
		output reg [1:0] outControlSig
    );

	always @(posedge clk) 
		begin
			if(hit!==0) 
				begin
					outALUot <= ALUout;
					outMemoryOut <= MemoryOut;
					outWriteReg <= writeReg;
					outControlSig <= controlSig;
				end		
		end

endmodule
