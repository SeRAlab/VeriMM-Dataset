module top_module(
	input clk,
	input nreset,
	input [7:0] data,
	input load,
	output reg [7:0] q);always @(posedge clk or negedge nreset)
	if (!nreset)
		q <= 8'b11110000;
	else if (load)
		q <= data;

endmodule