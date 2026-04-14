module top_module (
	input clk,
	input a,
	input b,
	input c,
	output reg q);initial
		q = 0;
		
	always@(posedge clk) begin
		q <= a | b | c;
	end

endmodule