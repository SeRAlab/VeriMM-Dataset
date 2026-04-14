module top_module (
	input clk,
	input m,
	input n,
	output reg q);initial
		q = 0;
		
	always@(posedge clk) begin
		q <= ~(m | n);
	end

endmodule