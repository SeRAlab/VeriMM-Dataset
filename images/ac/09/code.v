module top_module (
	input i, 
	input j, 
	input k, 
	input l,
	output reg n);assign n = i | ~j^k | ~i&~l;

endmodule