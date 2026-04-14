module combinational_circuit (
	input h,
	input i,
	input j,
	input k,
	output reg l);assign l = (~h & ~i & j & k) | (h & ~i & j & k) | (~h & i & ~j & ~k) | (h & i & j & k);

endmodule