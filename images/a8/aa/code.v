module top_module (
	input y,
	input z,
	output reg a);assign a = ~y | ~z;

endmodule