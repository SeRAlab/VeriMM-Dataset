module three_bit_counter(
	input clk,
	output reg [2:0] q);initial
	q = 3'b000;
		
always @(posedge clk)
	if (q == 3'b111)
		q <= 3'b000;
	else
		q <= q + 1;

endmodule