module sync_reset_counter (
	input clk,
	input rst,
	output reg [2:0] q);always @(posedge clk)
	if (rst)
		q <= 0;
	else
		q <= q + 1'b1;
		
endmodule