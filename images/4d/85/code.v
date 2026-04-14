module sync_up_counter_with_max(
	input clk,
	output reg [9:0] q);

initial
		q = 10'b0000000000;
		
always @(posedge clk)
	if (q == 10'b1111111111)
		q <= 10'b0000000000;
	else
		q <= q + 1;

endmodule