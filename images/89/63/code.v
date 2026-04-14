module top_module (
	input clk,
	input x,
	input y,
	output reg q);initial
		q = 0;
		
	always@(posedge clk) begin
		q <= x | y;
	end

endmodule