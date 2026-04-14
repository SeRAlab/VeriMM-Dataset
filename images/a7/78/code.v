module top_module (
	input clk,
	input x,
	input y,
	input z,
	output reg q);initial
		q = 0;
		
	always@(posedge clk) begin
		q <= x & y & z;
	end

endmodule