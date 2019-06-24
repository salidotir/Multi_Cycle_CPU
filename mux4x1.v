`timescale 1ns / 1ps

module mux4x1 (a, b, c, d, sel, out);
	input [31:0] a;
	input [31:0] b;
	input [31:0] c;
	input [31:0] d;
	input [1:0] sel;
	output reg [31:0] out;

	always @(a, b, c, d, sel)
	begin
		if(sel == 0)
			out = a;
		else if(sel == 1)
			out = b;
		else if (sel == 2)
			out = c;
		else if (sel == 3)
			out = d;
	end

/*
	always@(sel)
	begin
		case(sel)
			2'b00:
				out <= a;
			2'b01:
				out <= b;
			2'b10:
				out <= c;
			2'b11:
				out <= d;
		endcase
	end
*/

endmodule
