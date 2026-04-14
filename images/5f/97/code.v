module top_module (
	input [3:0] c,
	output [3:0] rev_bits,
	output parity);assign rev_bits = {c[0], c[1], c[2], c[3]};
	assign parity = ^c;
	
endmodule