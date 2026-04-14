module top_module (
	input x,
	input y,
	input z,
	output reg w);assign w = ~((x ^ y) ^ z);
endmodule