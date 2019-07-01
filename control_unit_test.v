`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:12:40 06/12/2019
// Design Name:   control_unit
// Module Name:   C:/Users/surface/Desktop/sara/Computer Architecture/Project/multi_cycle_cpu/control_unit_test.v
// Project Name:  multi_cycle_cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: control_unit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module control_unit_test;

	// Inputs
	reg clk;
	reg [5:0] Opcode;
	reg [5:0] Funct;

	// Outputs
	wire IorD;
	wire MemWrite;
	wire IRWrite;
	wire PCWrite;
	wire Branch;
	wire [1:0] PCSrc;
	wire [3:0] ALUControl;
	wire [1:0] ALUSrcB;
	wire ALUSrcA;
	wire RegWrite;
	wire Mem2Reg;
	wire RegDst;

	// Instantiate the Unit Under Test (UUT)
	control_unit uut (
		.clk(clk), 
		.Opcode(Opcode), 
		.Funct(Funct), 
		.IorD(IorD), 
		.MemWrite(MemWrite), 
		.IRWrite(IRWrite), 
		.PCWrite(PCWrite), 
		.Branch(Branch), 
		.PCSrc(PCSrc), 
		.ALUControl(ALUControl), 
		.ALUSrcB(ALUSrcB), 
		.ALUSrcA(ALUSrcA), 
		.RegWrite(RegWrite), 
		.Mem2Reg(Mem2Reg), 
		.RegDst(RegDst)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		Opcode = 6'h23;			// lw
		Funct = 0;

		// Wait 100 ns for global reset to finish
		#1000;
        
		// Add stimulus here
		
		Opcode = 6'h2b;			// sw
		Funct = 0;
		
		#1000;
		
		Opcode = 6'h2;				// jump
		Funct = 0;
		
		#1000;
		
		Opcode = 6'h8;				// addi
		Funct = 0;
		
		#1000;
		
		Opcode = 6'h4;				// beq
		Funct = 0;
	
		#1000;
	
		Opcode = 0;					// R_type
		Funct = 0;					// add
		
		#1000;
	
		Opcode = 0;					// R_type
		Funct = 5;					// and


	end
	
	always begin
		#100;
		clk = ~clk;
	end;
      
endmodule

