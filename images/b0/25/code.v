module top_module (
	input clk,
	input m,
	input n,
	output reg p,
	output reg state);reg q;
	always @(posedge clk)
		q <= m&n | q&~m;

	assign p = q;
	assign state = q;
			
endmodule