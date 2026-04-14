module top_module (
	input [7:0] a,
	input [7:0] b,
	output [7:0] out_and,
	output [7:0] out_or);assign out_and = a & b;
assign out_or = a | b;

endmodule