module top_module (
	input c,
	input d,
	output reg z);assign z = c & ~d;
endmodule