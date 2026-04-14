module top_module (
	input [9:0] data,
	output parity);assign parity = ^data;

endmodule