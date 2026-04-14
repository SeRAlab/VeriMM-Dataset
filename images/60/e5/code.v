module up_counter(
	input clk,
	output reg [3:0] q);initial
		q = 4'b0000;
		
	always @(posedge clk)
		q <= q + 1;
	
endmodule