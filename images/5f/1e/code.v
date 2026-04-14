module sync_reset_counter(
	input clk,
	input reset,
	output reg [3:0] q);initial
		q = 4'b0000;
		
	always @(posedge clk)
		if (reset)
			q <= 4'b0000;
		else
			q <= q + 1;
	
endmodule