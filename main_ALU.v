`timescale 1ns / 1ps

module main_ALU(srca, srcb, clk, ALUControl, ALUout, zero);
	input [31:0] srca, srcb;
	input clk;
	input [3:0] ALUControl;
	output reg [31:0] ALUout;
	output reg zero;

	always @(ALUControl , srca , srcb)
	begin
		if ( srca == srcb)						// set zero flag
			zero <= 1'b1;
		if (~(srca == srcb))
			zero <= 1'b0;
		if (ALUControl == 4'b0000)					// add
			ALUout <= srca + srcb;
		else if (ALUControl == 4'b0001)			// subtract
			ALUout <= srca - srcb;
		else if (ALUControl == 4'b0010)			// multiply
			ALUout <= srca * srcb;	
		else if (ALUControl == 4'b0011)			// division
			ALUout <= srca / srcb;
		else if (ALUControl == 4'b0100)			// xor
			ALUout <= srca ^ srcb;
		else if (ALUControl == 4'b0101)			// and
			ALUout <= srca & srcb;
		else if (ALUControl == 4'b0110)			// or
			ALUout <= srca | srcb;
		else if (ALUControl == 4'b0111)			// not
			ALUout <= ~srca;
		else if (ALUControl == 4'b 1000)			// nor
			ALUout <= ~(srca | srcb);
		else if (ALUControl == 4'b1001)			// set less than
			if (srca < srcb)
				ALUout <= 32'b1;
			else
				ALUout <= 32'b0;
		else if (ALUControl == 4'b1010)			// shift left logical
			ALUout <= srca << srcb;
		else if (ALUControl == 4'b1011)			// shift right logical
			ALUout <= srca >> srcb;
		else if (ALUControl == 4'b1100)			// shift right arithmetic
			ALUout <= srca >>> srcb;
		end

endmodule
