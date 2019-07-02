`timescale 1ns / 1ps

module inst_data_memory(pc_address, write_data, clk, mem_write, read_inst);
	input clk;
	input mem_write;
	input [31:0] write_data;
	input [5:0] pc_address;
	output  [31:0] read_inst;
	reg [31:0] read_inst;
	
	reg [31:0] inst_data_memory [31:0];
	
	always @(posedge clk)
	begin
	 if(mem_write == 1'b1)
			inst_data_memory[pc_address] <= write_data;
	/* else if(mem_write == 1'b0)
		  read_inst <= inst_data_memory[pc_address];
	*/end
	always@(pc_address)
	begin
		  read_inst <= inst_data_memory[pc_address];
	end
	initial begin
		inst_data_memory[0] <= 32'h00011800; // add
		//inst_data_memory[0] <= 32'h00000000;
		//inst_data_memory[1] <= 32'hffffffff;
		inst_data_memory[1] <= 32'h08000002; //jump to 8
		inst_data_memory[2] <= 32'h00000000; //no attention
		inst_data_memory[8] <= 32'h0040000d; //jr 
		inst_data_memory[9] <= 32'h00000000; //no attention
		inst_data_memory[20] <= 32'h00011800;//add
	end
	
//	initial begin
//		$readmemb("inst_data_memory.txt", inst_data_memory, 0);
//	end

endmodule
