module binary_counter_with_load(
	input clk,
	input reset,
	input load,
	input [3:0] d,
	output reg [3:0] q);always @(posedge clk)
	if (reset)
		q <= 4'b0000;
	else if (load)
		q <= d;
	else
		q <= q + 1;

endmodule