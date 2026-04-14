module example_module (
	input x,
	input y,
	input z,
	input w,
	output reg p);assign p = x&y&z&w | ~x&y&~z&w | x&y&~z&~w | x&~y&~z&w | ~x&~y&z&~w;

endmodule