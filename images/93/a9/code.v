module top_module(unshifted, shifted);input[31:0] unshifted;
	output[31:0] shifted;
	assign shifted = unshifted<<2;endmodule