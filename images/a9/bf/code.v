module top_module (
	input clk,
	input h,
	input j,
	output reg k,
	output reg state);reg o;
	always @(posedge clk)
		o <= h&j | o&~h;

	assign k = o;
	assign state = o;
			
endmodule