module top_module (
	input [3:0] in,
	output reg [2:0] count);always @(*)
	count = in[0] + in[1] + in[2] + in[3];

endmodule