module top_module (
	input [31:0] a,
	input [31:0] b,
	output [31:0] out_max,
	output [31:0] out_min);assign out_max = (a > b) ? a : b;
assign out_min = (a < b) ? a : b;

endmodule