`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:49:48 07/03/2019 
// Design Name: 
// Module Name:    interrupt 
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
module interrupt(
    );

	reg INT_control, NMI_control;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INTERRUPT	
	
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ NON_MASKABLE
	
	always@(posedge NMI)
	begin
		NMI_control <= 1;
		if(state == 0)
			NMI_control <= 0;
	end
	
	
	
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MASKABLE
	
	always@(INT)
	begin
		if(INT == 1)
			begin
				if(INT_Disable == 0 && NMI_control == 0)
					INT_control <= 1;
				else if(INT_Disable == 0 && NMI_control == 1)
					begin
						INT_control <= 0;
						INA <= 1;
					end
				else if(INT_Disable == 1)
					INT_control <= 0;
			end
			
		else if (INT == 0)
			begin
				INT_control <= 0;
			end
		if(state == 0)
		begin
		
			INT_control <= 0 ;
			INA <= 0 ;
		end
	end
	

endmodule
