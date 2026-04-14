module top_module (
	input c1,
	input c2,
	output reg c_out);assign c_out = ~(c1 ^ c2);
endmodule