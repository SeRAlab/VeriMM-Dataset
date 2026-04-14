module top_module (
	input clk,
	input w,
	input x,
	input y,
	input z,
	output reg out);initial
		out = 0;
		
	always@(posedge clk) begin
		out <= w | x | y | z;
	end

endmodule