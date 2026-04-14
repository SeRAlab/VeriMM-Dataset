module up_down_counter(
	input clk,
	input dir,
	output reg [1:0] q);always @(posedge clk)
	if (dir)
		q <= q + 1;
	else
		q <= q - 1;

endmodule