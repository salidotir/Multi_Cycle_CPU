
`timescale 1ns / 1ps

module data_register(clk, read_inst, data);
	input clk;
	input [31:0] read_inst;
	output reg [31:0] data;
	
	always @(posedge clk)
	begin
		data <= read_inst;			// in lw, we get all 32-bit as data.
	end

endmodule
