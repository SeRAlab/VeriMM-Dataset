module register(
	input clk,
	input load,
	input [15:0] data_in,
	output reg [15:0] q);

always @(posedge clk)
	if (load)
		q <= data_in;

endmodule