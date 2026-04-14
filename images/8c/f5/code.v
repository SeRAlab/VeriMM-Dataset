module binary_counter(
	input clk,
	output reg [1:0] q);initial
		q = 2'b00;
		
	always @(posedge clk)
		q <= q + 1;
	
endmodule