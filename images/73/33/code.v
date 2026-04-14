module top_module (
	input clk,
	input m,
	input n,
	output reg o,
	output reg state);reg j;
	always @(posedge clk)
		j <= m&n | j&~m;

	assign o = j;
	assign state = j;
			
endmodule