`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:24:03 06/12/2019 
// Design Name: 
// Module Name:    cpu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module cpu(clk , INT , NMI , INT_Disable , INA);

	input clk , INT , NMI , INT_Disable;
	output  reg INA;
	
	reg [31:0] pc ;
	wire IorD;									// inst or data
	wire mem_write;							// memory enable	
	wire IRWrite;								// instruction register enable
	wire [1:0] RegDst, Mem2Reg;
	wire [1:0] pc_src;
	wire [3:0] alu_control;
	wire RegWrite, branch, pc_write;
	wire [1:0]  alu_src_b ,alu_src_a;
	wire [31:0] next_pc, alu_out;
	wire [31:0] address;						// output wire of pc_mux
	wire [31:0] read_inst;					// output of memory
	wire [31:0] data;							// data register output
	wire [4:0] ra, rb, wr1, wr2 , shift_amt;
	wire [15:0] sign;
	wire [25:0] addr;							// address output of inst register (jump)
	wire [5:0] opcode, funct;
	wire [4:0] wr;
	wire [31:0] wd;
	wire [31:0] sign_imm;
	wire [31:0] rda, rdb;
	wire [31:0] a, b;
	wire [31:0] shift_sign_imm;
	wire [31:0] src_a;
	wire [31:0] src_b;
	wire [31:0] alu_result;
   wire [31:0] pc_jump_1;
	wire [31:0] pc_jump_concat;
	wire [31:0] shift_amt_concat;
	wire zero;
	wire [31:0] new_pc;
	wire [1:0] int_src; 
	
	assign pc_en = (zero & branch) | pc_write;
	
	
	
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CPU
	

	reg INT_control, NMI_control;
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INTERRUPT	
	
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ NON_MASKABLE
	
	always@(posedge NMI,negedge NMI)
	begin
		if(NMI == 1)
			NMI_control = 1;
		else if (NMI == 0)
			NMI_control = 0;
	end
	
	
	
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MASKABLE
	
	always@(INT)
	begin
		if(INT == 1)
			begin
				if(INT_Disable == 0 && NMI == 0)
					INT_control = 1;
				else if(INT_Disable == 0 && NMI == 1)
					begin
						INT_control = 0;
						INA = 1;
					end
				else if(INT_Disable == 1)
					INT_control = 0;
			end
			
		else if (INT == 0)
			begin
				INT_control = 0;
			end
	end
	
	
	
	
	/*
	
	
	wire INT_control, NMI_control;
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INTERRUPT	
	
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ NON_MASKABLE
	
	always@(NMI)
	begin
		if(NMI == 1)
			assign NMI_control = 1;
		else if (NMI == 0)
			assign NMI_control = 0;
	end
	
	
	
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MASKABLE
	
	always@(INT)
	begin
		if(INT == 1)
			begin
				if(INT_Disable == 0 && NMI_control == 0)
					assign INT_control = 1;
				else if(INT_Disable == 0 && NMI_control == 1)
					begin
						assign INT_control = 0;
						assign INA = 1;
					end
				else if(INT_Disable == 1)
					assign INT_control = 0;
			end
			
		else if (INT == 0)
			begin
				assign INT_control = 0;
			end
	end
	
	
	
	*/
	
	
	
	
	
	// control unit
	control_unit cu (
		 .clk(clk), 
		 .INT_control(INT_control), 
		 .NMI_control(NMI_control), 
		 .Opcode(opcode), 
		 .Funct(funct), 
		 .IorD(IorD), 
		 .MemWrite(mem_write), 
		 .IRWrite(IRWrite), 
		 .PCWrite(pc_write), 
		 .Branch(branch), 
		 .PCSrc(pc_src), 
		 .ALUControl(alu_control), 
		 .ALUSrcB(alu_src_b), 
		 .ALUSrcA(alu_src_a), 
		 .RegWrite(RegWrite), 
		 .Mem2Reg(Mem2Reg), 
		 .RegDst(RegDst),
		 .INTSrc(int_src)
		 );
	// pc register
	/*pc_register pc_reg (
		 .clk(clk), 
		 .pc(temp_pc), 
		 .pc_en(pc_en),
		 .next_pc(pc)
		 );
	*/
	reg flagpc = 1;
	always@ (posedge clk) 
	begin
		if(flagpc == 1)
		begin
			pc <= 0;
			flagpc <= 0;
		end
		else if(flagpc == 0)
		begin
			if(pc_en == 1'b1)
				begin
					pc <= next_pc;
				end
		end	
	end			


	// pc multiplexer
	mux2x1 pc_mux2x1_32 (
		 .a(pc), 
		 .b(alu_out), 
		 .sel(IorD), 
		 .out(address)
		 );
		 
	// instruction data memory
	inst_data_memory inst_data_memory (
		 .pc_address(address[5:0]), 
		 .write_data(b), 
		 .clk(clk), 
		 .mem_write(mem_write), 
		 .read_inst(read_inst)
		 );
		 
	// data register
	data_register data_reg (
		 .clk(clk), 
		 .read_inst(read_inst), 
		 .data(data)
		 );
		 
	// inst register
	inst_register inst_reg(
		 .clk(clk), 
		 .read_inst(read_inst), 
		 .IRWrite(IRWrite), 
		 .ra(ra), 
		 .rb(rb), 
		 .wr1(wr1), 
		 .wr2(wr2), 
		 .shift_amt(shift_amt),
		 .sign_extend(sign), 
		 .address(addr),
		 .opcode(opcode), 
		 .funct(funct)
	 );
		 		 
	// wr multiplexer
	mux4x1 #(.x(5)) wr_mux4x1_5(
		 .a(wr1), 
		 .b(wr2), 
		 .c(5'd31), 					// Register 31, return address in jal
		 .d(0),                    //is not used
		 .sel(RegDst), 
		 .out(wr)
		 );

	 
	// wd multiplexer
	mux4x1 wd_mux4x1_32 (
		 .a(alu_out), 
		 .b(data), 
		 .c(pc),                   //for jal
		 .d(0),                    //is not used
		 .sel(Mem2Reg), 
		 .out(wd)
		 );
	
	
	// sign extend
	sign_extend sign_ext (
		 .In(sign), 
		 .Out(sign_imm)
		 );

	//Register File
	register_file reg_file	(
		 .ra(ra), 
		 .rb(rb), 
		 .wr(wr), 
		 .wd(wd), 
		 .we(RegWrite), 
		 .clk(clk), 
		 .rda(rda), 
		 .rdb(rdb)
		 );

	// a_b register
	a_b_register a_b_reg (
		 .rda(rda), 
		 .rdb(rdb), 
		 .a(a), 
		 .b(b), 
		 .clk(clk)
		 );
		 
	// shift sign
	shift2 shift_sign (
    .in(sign_imm), 
    .out(shift_sign_imm)
    );

	
	 // concat shift_amt with 0.
	 assign shift_amt_concat[4:0] = shift_amt[4:0];
	 assign shift_amt_concat[31:5] = 0; 
	  
	// SrcA multiplexer
	mux4x1 src_a_mux4x1_32 (
		 .a(pc), 
		 .b(a), 
		 .c(shift_amt_concat),     //for shift inst.
		 .d(0),                    //is not used
		 .sel(alu_src_a), 
		 .out(src_a)
		 );
		 
	// SrcB multiplexer
	mux4x1 src_b_mux4x1_32 (
		 .a(b), 
		 .b(32'd1), 
		 .c(sign_imm), 
		 .d(shift_sign_imm),
		 .sel(alu_src_b), 
		 .out(src_b)
		 );
		 
	// main ALU
	main_ALU alu_main (
		 .srca(src_a), 
		 .srcb(src_b), 
		 .clk(clk), 
		 .ALUControl(alu_control), 
		 .ALUout(alu_result), 
		 .zero(zero)
		 );
		 
	// alu_result 2 alu_out register
	data_register alu_result_reg (
		 .clk(clk), 
		 .read_inst(alu_result), 
		 .data(alu_out)
		 );
		 
 	// shift sign
	shift2 #(.x(26)) shift_sign_jump (
    .in(addr), 
    .out(pc_jump_1)
    );
	 
	 // concat pc_jump_1 with 4_MSB of pc.
	 assign pc_jump_concat[27:0] = pc_jump_1[27:0];
	 assign pc_jump_concat[31:28] = pc[31:28]; 
	  
	// pc_jump multiplexer
	mux4x1 pc_jump_mux4x1_32 (
		 .a(alu_result), 
		 .b(alu_out), 
		 .c(pc_jump_concat),               //for jump and jal
		 .d(rda),								  //for jr
		 .sel(pc_src), 
		 .out(new_pc)								
		 );
	
	// interrupt multiplexer
	mux4x1 interrupt_mux4x1_32 (
		 .a(new_pc), 
		 .b(32'd27),                        //NMI jump address  
		 .c(32'd28),                        //INT jump address
		 .d(0),									   // the fourth input is not used.
		 .sel(int_src), 
		 .out(next_pc)								// next pc is in pc.
		 );
	
endmodule
