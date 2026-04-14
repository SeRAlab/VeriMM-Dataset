module top_module (
	input [7:0] m,
	input [7:0] n,
	output [7:0] out_add,
	output [7:0] out_sub);assign out_add = m + n;
assign out_sub = m - n;

endmodule