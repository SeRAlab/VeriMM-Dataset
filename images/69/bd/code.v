module top_module (
	input clk,
	input a,
	input b,
	output reg y,
	output reg state);reg q;
	always @(posedge clk)
		q <= a | (q & b);

	assign y = q;
	assign state = q;
			
endmodule