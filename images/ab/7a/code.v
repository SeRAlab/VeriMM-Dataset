module logic_system (
	input g,
	input h,
	input i,
	input j,
	output reg k);assign k = (g & ~h & i & ~j) | (g & h & ~i & j) | (g & h & i & j);

endmodule