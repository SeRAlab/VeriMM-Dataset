module binary_counter_with_enable_and_clear(
	input clk,
	input enable,
	input clear,
	output reg [2:0] q);initial
		q = 3'b000;
		
	always @(posedge clk)
		if (clear)
			q <= 3'b000;
		else if (enable)
			q <= q + 1;
	
endmodule