module top_module (
	input a,
	input b,
	input c,
	output reg d);assign d = ~((a & b) & c);
endmodule