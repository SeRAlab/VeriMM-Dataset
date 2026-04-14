module top_module(
		input A,
		input B,
		input CarryIn,
		input clk,
		output reg S,
		output reg CarryOut
		);always @ (posedge clk)
	begin
		S = (A ^ B) ^ CarryIn;
		CarryOut = (B & CarryIn) | (A & B) | (A & CarryIn);
	end
endmodule