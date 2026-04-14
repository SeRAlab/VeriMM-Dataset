module top_module(
	input ALUSrc,
	input [7:0] Read_Data,
	input [7:0] Imm_Data,
	output [7:0] Result
    );reg [7:0] operand1; 
	
	assign Result = operand1 + Imm_Data;
	
	always @(Read_Data, Imm_Data)
	begin
		if(ALUSrc == 0) 
		begin
			operand1 = 0;	
		end
		
		else 
		begin
			operand1 = Read_Data;
		end
		
		
	end

endmodule