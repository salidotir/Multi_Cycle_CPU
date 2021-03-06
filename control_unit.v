`timescale 1ns / 1ps

module control_unit(clk,NMI ,INT_control , NMI_control ,Opcode, Funct, IorD, MemWrite, IRWrite, PCWrite, Branch, PCSrc,
						  ALUControl, ALUSrcB, ALUSrcA, RegWrite, Mem2Reg, RegDst , INTSrc);
	input clk ,  INT_control , NMI_control ,NMI;
	input [5:0] Opcode, Funct;
	output reg [3:0] ALUControl;
	output reg [1:0] ALUSrcB, PCSrc ,  ALUSrcA , INTSrc;
	output reg IorD, MemWrite, IRWrite, PCWrite, Branch, RegWrite;
	output reg [1:0]	Mem2Reg, RegDst;
	
	// states
	reg [4:0] state = 0;
	reg [4:0] next_state = 0;
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
	parameter s11 = 11;				// jump register 
	parameter s12 = 12;				// jump & link
	parameter s13 = 13;				// lw & sw
	parameter s14 = 14;           //INT
	parameter s15 = 15;
	
	reg tmp_NMI_control = 0 ,tmp_INT_control = 0;
	reg temp = 0;

	reg flags = 1;
	always @(posedge clk)
	begin
	
		if(flags == 1)
			begin
				state = 0;
				flags = 0;
			end
		else if(flags == 0)
			begin
				state = next_state;
			end
		end
	

	
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CONTROL UNIT
	always @(state, Opcode , Funct , NMI)
	begin
		
		temp = tmp_NMI_control | NMI;
		
		case(state)
			0:
			begin
				//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INTERRUPT
				if(NMI_control == 1 )begin
					tmp_NMI_control = 1;
					end
			   else if (INT_control == 1)begin
					tmp_INT_control = 1;
					end
						
				if((tmp_INT_control === 1) || (INT_control == 1))
				begin
					next_state = s14;
				end
				
				//else if(tmp_NMI_control == 1 || NMI_control == 1)
				else if(temp)
				begin
					if(NMI == 0)
					begin
						next_state = s15;
					end
					if(NMI == 1)
					begin
						IorD = 0;
						ALUSrcA = 0;
						ALUSrcB = 2'b01;
						ALUControl = 0;				// add in the alu
						PCSrc = 2'b00;
						INTSrc = 2'b00;
						IRWrite = 1;
						PCWrite = 1;	
						MemWrite = 0;
						Mem2Reg = 0;
						RegWrite = 0;
						Branch = 0;
						
						next_state = s1;
				
					end
					
				end				
				
				else
				begin
					IorD = 0;
					ALUSrcA = 0;
					ALUSrcB = 2'b01;
					ALUControl = 0;				// add in the alu
					PCSrc = 2'b00;
					INTSrc = 2'b00;
					IRWrite = 1;
					PCWrite = 1;	
					MemWrite = 0;
					Mem2Reg = 0;
					RegWrite = 0;
					Branch = 0;
					
					next_state = s1;
				
				end
			end

			1:
			begin
				if(NMI_control == 1 )
					tmp_NMI_control = 1;
				else if (INT_control == 1)
					tmp_INT_control = 1;
					
				ALUSrcA = 0;
				ALUSrcB = 2'b11;
				ALUControl = 0;				// add in the alu
				IRWrite = 0;
				PCWrite = 0;
				
				case(Opcode)
					6'h23:						// lw
						next_state = s13;
					
					6'h2b:						// sw
						next_state = s13;
						
					6'h0:							// R-type functions
						next_state = s5;
						
					6'h4:							// branch on equal
						next_state = s7;
						
					6'h8:							// addi
						next_state = s8;
					
					6'h2:							// jump
						next_state = s10;
					
					6'h3:                  //jal
						next_state = s11;
				endcase
			end
			
			2:
			begin
				if(NMI_control == 1 )
					tmp_NMI_control = 1;
				else if (INT_control == 1)
					tmp_INT_control = 1;
					
				IorD = 1;
				
				next_state = s3;
			end
				
			3:
			begin
				if(NMI_control == 1 )
					tmp_NMI_control = 1;
				else if (INT_control == 1)
					tmp_INT_control = 1;
			
				RegDst = 0;
				Mem2Reg = 1;
				RegWrite = 1;
				
				next_state = s0;
			end
			
			4:
			begin
				if(NMI_control == 1 )
					tmp_NMI_control = 1;
				else if (INT_control == 1)
					tmp_INT_control = 1;
					
				IorD = 1;
				MemWrite = 1;
				
				next_state = s0;
			end
			
			5:
			begin
				if(NMI_control == 1 )
					tmp_NMI_control = 1;
				else if (INT_control == 1)
					tmp_INT_control = 1;
					
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
							ALUControl = 10;      //shift left logical
							ALUSrcA = 2;
						end
						
						11:
						begin
							ALUControl = 11;      //shift right logical
							ALUSrcA = 2;
						end
						
						12:
						begin
							ALUControl = 12;     //shift right arithmetic
							ALUSrcA = 2;
						end
					endcase
				end
				
				next_state = s6;
				
				if(Funct == 6'b001101) //jr
				begin
					next_state = s12;
				end
			end
			
			6:
			begin
				if(NMI_control == 1 )
					tmp_NMI_control = 1;
				else if (INT_control == 1)
					tmp_INT_control = 1;
					
				RegDst = 1;
				Mem2Reg = 0;
				RegWrite = 1;
				
				next_state = s0;
			end
			
			7:
			begin
				if(NMI_control == 1 )
					tmp_NMI_control = 1;
				else if (INT_control == 1)
					tmp_INT_control = 1;
					
				ALUSrcA = 1;
				ALUSrcB = 2'b00;
				ALUControl = 1;				// sub in the alu for beq
				PCSrc = 2'b01;
				INTSrc = 2'b00;
				Branch = 1;
				
				next_state = s0;
			end
			
			8:
			begin
				if(NMI_control == 1 )
					tmp_NMI_control = 1;
				else if (INT_control == 1)
					tmp_INT_control = 1;
					
				ALUSrcA = 1;
				ALUSrcB = 2'b10;
				ALUControl = 0;				// add in the alu

				next_state = s9;
			end
			
			9:
			begin
				if(NMI_control == 1 )
					tmp_NMI_control = 1;
				else if (INT_control == 1)
					tmp_INT_control = 1;
					
				RegDst = 0;
				Mem2Reg = 0;
				RegWrite = 1;
				
				next_state = s0;
			end
			
			10:             //j
			begin
				if(NMI_control == 1 )
					tmp_NMI_control = 1;
				else if (INT_control == 1)
					tmp_INT_control = 1;
					
				PCSrc = 2'b10;
				PCWrite = 1;
				INTSrc = 2'b00;
				
				next_state = s0;
			end
			
			11:             //jal
			begin
				if(NMI_control == 1 )
					tmp_NMI_control = 1;
				else if (INT_control == 1)
					tmp_INT_control = 1;				

				PCSrc = 2'b10;
				PCWrite = 1;
				INTSrc = 2'b00;
				RegDst = 2;
				Mem2Reg = 2;
				RegWrite = 1;
				
				next_state = s0;
			end
			
			12:              //jr
			begin
				if(NMI_control == 1 )
					tmp_NMI_control = 1;
				else if (INT_control == 1)
					tmp_INT_control = 1;
					
				PCSrc = 2'b11;
				PCWrite = 1;
				INTSrc = 2'b00;
				
				next_state = s0;
			end
			
			13:                 //lw and sw in common
			begin
				if(NMI_control == 1 )
					tmp_NMI_control = 1;
				else if (INT_control == 1)
					tmp_INT_control = 1;
					
				ALUSrcA = 1;
				ALUSrcB = 2'b10;
				ALUControl = 0;				// add in the alu
				
				if(Opcode == 6'h23)
					next_state = s2;
				else if(Opcode == 6'h2b)
					next_state = s4;
			end
			
			14:
			begin
				tmp_INT_control = 0;
				INTSrc = 2'b10;
				IorD = 0;
				RegWrite = 1;
				RegDst = 2'b10;
				Mem2Reg = 2'b10;
				PCWrite = 1;
				
				next_state = s0;
			end
			
			15:
			begin
				temp = 0;
				tmp_NMI_control = 0;
				INTSrc = 2'b01;
				IorD = 0;
				RegWrite = 1;
				RegDst = 2'b10;
				Mem2Reg = 2'b10;
				PCWrite = 1;
				
				next_state = s0;

			end
		endcase
	end

endmodule
