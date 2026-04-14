module top_module(
	input [31:0] theInput,
	output [31:0] resultOfShiftLeft2
);assign resultOfShiftLeft2 [31:0] = theInput [31:0] << 2;endmodule