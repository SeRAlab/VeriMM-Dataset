module top_module (
	input clk,
	input a,
	input b,
	output reg q);initial
		q = 0;
		
	always@(posedge clk) begin
		q <= a ^ b;
	end

endmodule