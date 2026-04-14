module binary_counter(
	input clk,
	input clear_n,
	output reg [4:0] q);
	
always @(posedge clk)
	if (!clear_n)
		q <= 5'b00000;
	else
		q <= q + 1;

endmodule