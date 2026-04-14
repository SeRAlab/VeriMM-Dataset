module top_module (
	input [15:0] p,
	input [15:0] q,
	output [15:0] out_xor,
	output [15:0] out_not);assign out_xor = p ^ q;
assign out_not = ~p;

endmodule