module top_module(
input [4:0] FUNCT,
input ALU_Op,
output reg [2:0] 	ALU_Ctrl,
output reg [1:0] 	Flag_Write,
output reg 	No_Write
);always @ (FUNCT or ALU_Op)
	begin

		if(!ALU_Op) 
		begin
			ALU_Ctrl = 3'b000;
			No_Write = 0;
			Flag_Write = 2'b00;
		end 
		else 
		begin
			
			if(FUNCT[4:1] == 4'b0100) 
			begin
				ALU_Ctrl = 3'b000;
				No_Write = 0;
				Flag_Write = FUNCT[0] ? 2'b11 : 2'b00;
			
			end 
			else if(FUNCT[4:1] == 4'b0010) 
			begin
				ALU_Ctrl = 3'b001;
				No_Write = 0;
				Flag_Write = FUNCT[0] ? 2'b11 : 2'b00;
			
			end 
			else if(FUNCT[4:1] == 4'b0000) 
			begin
				ALU_Ctrl = 3'b100;
				No_Write = 0;
				Flag_Write = FUNCT[0] ? 2'b10 : 2'b00;
			
			end 
			else if(FUNCT[4:1] == 4'b1100) 
			begin
				ALU_Ctrl = 3'b101;
				No_Write = 0;
				Flag_Write = FUNCT[0] ? 2'b10 : 2'b00;
			
			end 
			else if(FUNCT[4:1] == 4'b1010) 
			begin
				ALU_Ctrl = 3'b001;
				No_Write = 1;
				Flag_Write = 2'b11;
			end
		end
	end	
endmodule