module up_down_counter(
	input clk,
	input dir,
	output reg [2:0] q);initial
		q = 3'b000;
		
	always @(posedge clk)
		if (dir)
			q <= q + 1;
		else
			q <= q - 1;
endmodule