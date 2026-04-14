module top_module (
	input [15:0] in1,
	input [15:0] in2,
	output [15:0] out_nor);assign out_nor = ~(in1 | in2);

endmodule