`timescale 1ns / 1ps

module inst_data_memory(pc_address, write_data, clk, mem_write, read_inst);
	input clk;
	input mem_write;
	input [31:0] write_data;
	input [5:0] pc_address;
	output reg [31:0] read_inst;
	
	reg [31:0] inst_data_memory [31:0];
	
	always @(posedge clk)
	begin
		if(mem_write == 1'b0)
			read_inst <= inst_data_memory[pc_address];
		else if(mem_write == 1'b1)
			inst_data_memory[pc_address] <= write_data;
	end
	
	initial begin
		inst_data_memory[0] <= 32'hf0011800;
	end
	
//	initial begin
//		$readmemb("inst_data_memory.txt", inst_data_memory, 0);
//	end

endmodule
