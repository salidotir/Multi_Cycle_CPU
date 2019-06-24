`timescale 1ns / 1ps

module pc_register(clk, pc, pc_en, next_pc);
	input clk, pc_en;
	input [31:0] pc;
	output reg [31:0] next_pc;

	always @(posedge clk)
	begin
		if (pc_en == 1)
		begin
			next_pc <= pc;
		end
	end

endmodule
