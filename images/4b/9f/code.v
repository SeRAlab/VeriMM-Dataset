module top_module (
	input a1,
	input a2,
	input a3,
	input a4,
	output reg a_out);assign a_out = ~((a1 | a2 | a3) & a4);
endmodule