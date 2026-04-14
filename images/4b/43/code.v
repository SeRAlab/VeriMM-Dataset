module binary_counter_with_enable(
	input clk,
	input en,
	output reg [2:0] q);initial
		q = 3'b000;
		
	always @(posedge clk)
		if (en)
			q <= q + 1;
endmodule