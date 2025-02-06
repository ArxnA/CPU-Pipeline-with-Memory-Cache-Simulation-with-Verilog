`timescale 1ns / 1ps


module Mux5(
		input [4:0]A, B,
		input select,
		output [4:0]result
    );

	assign result = select ? B : A;

endmodule