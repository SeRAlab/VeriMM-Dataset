module binary_counter(
	input clk,
	output reg [1:0] q);initial
	q = 2'b00;
		
always @(posedge clk)
	if (q == 2'b11)
		q <= 2'b00;
	else
		q <= q + 1;

endmodule