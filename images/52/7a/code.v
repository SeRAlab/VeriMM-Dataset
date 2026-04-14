module top_module (
	input clk,
	input m,
	input n,
	output reg o,
	output reg state);reg f;
	always @(posedge clk)
		f <= m&n | m&f | n&f;
	
	assign o = m^n^f;
	assign state = f;
			
endmodule