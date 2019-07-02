
`timescale 1ns / 1ps

module inst_register(clk, read_inst, IRWrite, ra, rb, wr1 , wr2, sign_extend, address, opcode, funct , shift_amt);
	input clk, IRWrite;
	input [31:0] read_inst;
	output reg [4:0] ra, rb, wr1, wr2, shift_amt;
	output reg [15:0] sign_extend;
	output reg [25:0] address;
	output reg [5:0] opcode, funct;
	
	always @(posedge clk)
	begin
		if(IRWrite == 1'b1)
		begin
			ra <= read_inst[25:21];
			rb <= read_inst[20:16];
			wr1 <= read_inst[20:16];
			wr2 <= read_inst[15:11];
			shift_amt <= read_inst[10:6];
			sign_extend <= read_inst[15:0];
			address <= read_inst[25:0];
			opcode <= read_inst[31:26];
			funct <= read_inst[5:0];
		end
	end
		
endmodule
