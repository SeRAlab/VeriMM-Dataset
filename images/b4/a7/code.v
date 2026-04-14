module logic_circuit_v2 (
	input a,
	input b,
	input c,
	input d,
	output reg e);assign e = (a & ~b & c & ~d) | (a & b & c & d) | (a & b & ~c & d);

endmodule