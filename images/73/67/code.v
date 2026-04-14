module top_module (
	input [3:0] x,
	input [3:0] y,
	output [3:0] out_and,
	output [3:0] out_or);assign out_and = x & y;
assign out_or = x | y;

endmodule