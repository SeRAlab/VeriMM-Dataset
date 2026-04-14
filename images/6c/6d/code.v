module top_module(
	input [16:0]a,
	output [2:0]x,
	output [15:0]y
);assign x = a[2:0];
	assign y = a[16:1];

endmodule