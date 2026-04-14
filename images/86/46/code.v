module combinational_logic (
	input e,
	input f,
	input g,
	input h,
	output reg i);assign i = (~e & f & ~g & h) | (e & f & ~g & ~h) | (e & f & g & h);

endmodule