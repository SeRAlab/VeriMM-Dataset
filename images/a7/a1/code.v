module top_module (
	input clk,
	input dir,
	input [7:0] d, 
	output reg [7:0] q);always @(posedge clk)
	if (dir)
		q <= d >> 1;
	else
		q <= d << 1;
		
endmodule