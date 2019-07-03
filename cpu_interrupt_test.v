`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:22:01 07/03/2019
// Design Name:   cpu
// Module Name:   D:/term4/computer art/project/multi_cycle_cpu/1_multi_cycle_cpu/multi_cycle_cpu/cpu_interrupt_test.v
// Project Name:  multi_cycle_cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cpu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cpu_interrupt_test;

	// Inputs
	reg clk;
	reg INT;
	reg NMI;
	reg INT_Disable;

	// Outputs
	wire INA;

	// Instantiate the Unit Under Test (UUT)
	cpu uut (
		.clk(clk), 
		.INT(INT), 
		.NMI(NMI), 
		.INT_Disable(INT_Disable), 
		.INA(INA)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		NMI = 0;
		INT_Disable = 0;
		INT =0;
		#200;

		// Wait 100 ns for global reset to finish

		
		#50;
      INT = 1;
		NMI = 1;
		#30;
		INT_Disable = 1;
		
		#300;
		
		INT_Disable = 0;
		//#50;
		INT = 0;	
		NMI = 0;
		// Add stimulus here
		
		/*
		NMI = 1;
		#300;
		NMI = 0;
*/
	end
      
	always begin
		#100;
		clk = ~clk;
	end
	
endmodule

