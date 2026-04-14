module top_module (
	input i1, 
	input i2, 
	input i3, 
	input i4,
	output reg y);assign y = i1&~i2 | i3&~i4 | ~i1&i4;

endmodule