module top_module(
	input [32:0] x,
	input [31:0] d,
	output q,
	output [31:0] r
	);wire [33:0] sub;

	assign sub = { 1'b1,x } - { 2'b00,d };
	assign q = sub[33];
	assign r = q ? sub[31:0] : x[31:0];endmodule