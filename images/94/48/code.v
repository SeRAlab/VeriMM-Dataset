module top_module (
	input clk,
	input i,
	input j,
	output reg q);initial
		q = 0;
		
	always@(posedge clk) begin
		q <= ~(i & j);
	end

endmodule