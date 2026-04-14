module counter(
	input clk,
	input reset,
	input load,
	input [4:0] d,
	output reg [4:0] q);always @(posedge clk or posedge reset)
	if (reset)
		q <= 5'b00000;
	else if (load)
		q <= d;
	else
		q <= q + 1;

endmodule