
`timescale 1ns / 1ps

module a_b_register(rda, rdb, a, b, clk);
	input clk;
	input [31:0] rda, rdb;
	output reg [31:0] a, b;
	
	always @(posedge clk)
	begin
		a <= rda;
		b <= rdb;
	end

endmodule
