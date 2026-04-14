module top_module(
	input [3:0] binary,
	output [3:0] bcd);assign bcd = (binary > 9) ? 4'b1001 : binary;
endmodule