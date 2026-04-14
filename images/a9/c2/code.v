module sync_up_counter_with_enable(
	input clk,
	input enable,
	output reg [1:0] q);initial
		q = 2'b00;
		
	always @(posedge clk)
		if (enable)
			q <= q + 1;
	
endmodule