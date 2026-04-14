module top_module (
	input t, 
	input v, 
	input w, 
	input x,
	output reg u);assign u = t&~v | w&~x | ~t&x;

endmodule