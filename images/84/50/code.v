module top_module(
	input Clk,
	input Reset,
	input [7:0] Instruction_Code,
	output reg [7:0] IF_ID_Instruction_Code
    );always@(posedge Clk, negedge Reset)
	begin
		if (Reset==0) IF_ID_Instruction_Code <= 0;
		
		else IF_ID_Instruction_Code <= Instruction_Code;
	end

endmodule