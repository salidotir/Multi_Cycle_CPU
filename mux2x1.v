`timescale 1ns / 1ps

module mux2x1 #(parameter x = 32) ( a, b, sel, out);			// x can be 32 or 5.
	input [x-1:0] a;
	input [x-1:0] b;
	input sel;
	output [x-1:0] out;

	assign out = !sel ? a : b;

endmodule

