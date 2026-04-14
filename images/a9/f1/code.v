module top_module (
	input e, 
	input f, 
	input g, 
	input h,
	output reg s);assign s = (e & ~f & ~g & h) | (~e & f & ~h) | (e & f & ~g) | (~e & ~f & g);

endmodule