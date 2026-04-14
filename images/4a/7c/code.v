module binary_counter(
	input clk,
	input rst,
	output reg [7:0] q);always @(posedge clk or posedge rst)
	if (rst)
		q <= 8'b00000000;
	else
		q <= q + 1;

endmodule