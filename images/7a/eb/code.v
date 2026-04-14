module top_module (
	input clk,
	input i,
	input j,
	output reg k,
	output reg state);reg q;
	always @(posedge clk)
		q <= i & ~j;

	assign k = q;
	assign state = q;
			
endmodule