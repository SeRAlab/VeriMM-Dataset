module top_module(
	input wire [31:0] real_RFRD1,
	input wire [31:0] real_RFRD2,
	output wire zero
    );assign zero = (real_RFRD1 == real_RFRD2) ? 1'b1 : 1'b0;

endmodule