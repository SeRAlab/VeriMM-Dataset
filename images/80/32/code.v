module top_module (
	input x,
	input y,
	input z,
	output reg out);assign out = x | y | z;
endmodule