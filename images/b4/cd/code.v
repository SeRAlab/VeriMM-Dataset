module top_module (
	input [7:0] a,
	output out_parity);assign out_parity = ^a;

endmodule