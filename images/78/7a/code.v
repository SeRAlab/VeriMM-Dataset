module top_module (
	input t, 
	input u, 
	input v, 
	input w,
	output reg o);assign o = ~t&u | v&~w | t^~v;

endmodule