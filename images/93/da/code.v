module top_module (
	input clk,
	input d1,
	input d2,
	output reg q);initial
		q = 0;
		
	always@(posedge clk) begin
		q <= d1 & d2;
	end

endmodule