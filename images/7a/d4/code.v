module logic_design (
	input x,
	input y,
	input z,
	output reg w);assign w = (x & ~y & ~z) | (x & y & z) | (x & ~y & z);

endmodule