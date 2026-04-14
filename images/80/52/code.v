module top_module(
	input sel,
	input [15:0] in1,
	input [15:0] in0,
	output wire [15:0] out
);assign out = (sel) ? in1 : in0;


endmodule