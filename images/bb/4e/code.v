module top_module (
	input [7:0] c,
	output [6:0] out_product,
	output [6:0] out_or,
	output [7:0] out_xor);assign out_product = c[6:0] & c[7:1];
	assign out_or = c[6:0] | c[7:1];
	assign out_xor = c ^ {c[0], c[7:1]};
	
endmodule