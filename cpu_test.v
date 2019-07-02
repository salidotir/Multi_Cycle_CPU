`timescale 1ns / 1ps

module cpu_test;

	// Inputs
	reg clk;

	// Instantiate the Unit Under Test (UUT)
	cpu uut (
		.clk(clk)
	);

	initial begin
		// Initialize Inputs
		clk = 0;

		// Wait 100 ns for global reset to finish
		
        
		// Add stimulus here

	end
	
	always begin
		#100;
		clk = ~clk;
	end
      
endmodule

