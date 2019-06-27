
`timescale 1ns / 1ps

module shift2 #(parameter x = 32) (in, out);			// x can be 32 or 26
	input [x-1:0] in;
	output [31:0] out;
	
	assign out = in << 2;
	
	if(x == 26)begin
		assign out[x+5] = 0;
		assign out[x+4] = 0;
		assign out[x+3] = 0;
		assign out[x+2] = 0;
	end

endmodule
