`timescale 1ns / 1ps

module control_unit(clk, Opcode, Funct, IorD, MemWrite, IRWrite, PCWrite, Branch, PCSrc,
						  ALUControl, ALUSrcB, ALUSrcA, RegWrite, Mem2Reg, RegDst);
	input clk;
	input [5:0] Opcode, Funct;
	output reg [3:0] ALUControl;
	output reg [1:0] ALUSrcB, PCSrc;
	output reg IorD, MemWrite, IRWrite, PCWrite, Branch, ALUSrcA, RegWrite, Mem2Reg, RegDst;
	
	// states
	reg [3:0] state = 0;
	reg [3:0] next_state;
	parameter s0 = 0;					// fetch
	parameter s1 = 1;					// decode
	parameter s2 = 2;					// mem_read and mem_address
	parameter s3 = 3;					// mem_write_back
	parameter s4 = 4;					// mem_write and mem_address
	parameter s5 = 5;					// execute
	parameter s6 = 6;					// alu_write_back
	parameter s7 = 7;					// branch
	parameter s8 = 8;					// addi execute
	parameter s9 = 9;					// addi write_back
	parameter s10 = 10;				// jump

	/*always @(posedge clk)
	begin
		state = next_state;
	end
	*/
	always @(posedge clk)
	begin
		case(state)
			0:
			begin
				IorD = 0;
				ALUSrcA = 0;
				ALUSrcB = 2'b01;
				ALUControl = 0;				// add in the alu
				PCSrc = 2'b00;
				IRWrite = 1;
				PCWrite = 1;
			/*	
				MemWrite = 0;
				RegDst = 0;
				Mem2Reg = 0;
				RegWrite = 0;
				Branch = 0;
				*/
				next_state = s1;
			end

			1:
			begin
				ALUSrcA = 0;
				ALUSrcB = 2'b11;
				ALUControl = 0;				// add in the alu
				
				case(Opcode)
					6'h23:						// lw
						next_state = s2;
					
					6'h2b:						// sw
						next_state = s4;
						
					6'h0:							// R-type functions
						next_state = s5;
						
					6'h4:							// branch on equal
						next_state = s7;
						
					6'h8:							// addi
						next_state = s8;
					
					6'h2:							// jump
						next_state = s10;
				endcase
			end
			
			2:
			begin
				ALUSrcA = 1;
				ALUSrcB = 2'b10;
				ALUControl = 0;				// add in the alu
				IorD = 1;
				
				next_state = s3;
			end
				
			3:
			begin
				RegDst = 0;
				Mem2Reg = 1;
				RegWrite = 1;
				
				next_state = s0;
			end
			
			4:
			begin
				ALUSrcA = 1;
				ALUSrcB = 2'b10;
				ALUControl = 0;				// add in the alu
				IorD = 1;
				MemWrite = 1;
				
				next_state = s0;
			end
			
			5:
			begin
				ALUSrcA = 1;
				ALUSrcB = 2'b00;
				
				// set ALUControl for R-Type functions
				if (Opcode == 0)
				begin
					case(Funct)
						0:
						begin
							ALUControl = 0;
						end
						
						1:
						begin
							ALUControl = 1;
						end
						
						2:
						begin
							ALUControl = 2;
						end

						3:							
						begin
							ALUControl = 3;
						end

						4:							
						begin
							ALUControl = 4;
						end

						5:							
						begin
							ALUControl = 5;
						end
						
						6:						
						begin
							ALUControl = 6;
						end

						7:
						begin
							ALUControl = 7;
						end
						
						8:
						begin
							ALUControl = 8;
						end

						9:
						begin
							ALUControl = 9;
						end

						10:
						begin
							ALUControl = 10;
						end
						
						11:
						begin
							ALUControl = 11;
						end
						
						12:
						begin
							ALUControl = 12;
						end
					endcase
				end
				
				next_state = s6;
			end
			
			6:
			begin
				RegDst = 1;
				Mem2Reg = 0;
				RegWrite = 1;
				
				next_state = s0;
			end
			
			7:
			begin
				ALUSrcA = 1;
				ALUSrcB = 2'b00;
				ALUControl = 1;				// sub in the alu for beq
				PCSrc = 2'b01;
				Branch = 1;
				
				next_state = s0;
			end
			
			8:
			begin
				ALUSrcA = 1;
				ALUSrcB = 2'b10;
				ALUControl = 0;				// add in the alu

				next_state = s9;
			end
			
			9:
			begin
				RegDst = 0;
				Mem2Reg = 0;
				RegWrite = 1;
				
				next_state = s0;
			end
			
			10:
			begin
				PCSrc = 2'b10;
				PCWrite = 1;
				
				next_state = s0;
			end
			
			default:
				state = s0;
		endcase

	state = next_state;

	end

endmodule
