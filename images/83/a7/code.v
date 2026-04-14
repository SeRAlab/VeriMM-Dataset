module top_module (
	input clk,
	input w,
	input x,
	output reg y,
	output reg state);reg q;
	always @(posedge clk)
		q <= w & ~x;

	assign y = q;
	assign state = q;
			
endmodule