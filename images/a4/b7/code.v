module counter_with_enable(
	input clk,
	input enable,
	output reg [7:0] q);initial
		q = 8'b00000000;
		
	always @(posedge clk)
		if (enable)
			q <= q + 1;
	
endmodule