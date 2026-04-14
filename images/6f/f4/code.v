module logic_circuit (
	input a,
	input b,
	input c,
	input d,
	output reg z);assign z = (~a & ~b & c & ~d) | (a & b & c & ~d) | (~a & b & c & d) | (a & ~b & ~c & d) | (a & b & c & ~d);

endmodule