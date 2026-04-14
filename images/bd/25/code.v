module top_module (
	input u, 
	input v, 
	input w, 
	input x,
	output reg s);assign s = u | ~v^w | ~u&~x;

endmodule