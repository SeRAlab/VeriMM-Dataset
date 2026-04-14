module top_module(
	input [25:0] theInput,
	output [27:0] resultOfShiftLeft2Add2bits
);assign resultOfShiftLeft2Add2bits [27:0] = theInput [25:0] << 2;endmodule