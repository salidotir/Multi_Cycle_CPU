
`timescale 1ns / 1ps

module register_file(ra, rb, wr, wd, we, clk, rda, rdb);
	
	input [4:0] ra, rb, wr;
	input [31:0] wd;
	input we, clk;
	output reg [31:0] rda, rdb;
	
	reg [31:0] reg_file [31:0];
	
	always @(posedge clk) begin
		if (we == 1) begin
			reg_file[wr] <= wd;
		end
		
		rda <= reg_file[ra];
		rdb <= reg_file[rb];
			
	end
	
	initial begin
		reg_file[0] <= 32'hf0f0f0f0;
		reg_file[1] <= 32'hf0f0f0f0;
	end

endmodule
