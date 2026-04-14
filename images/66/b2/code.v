module output_logic (
	input x,
	input y,
	input z,
	input w,
	output reg v);assign v = ~x&y&~z&~w | x&~y&z&w | ~x&~y&z&w | x&y&~z&w | x&y&z&~w;

endmodule