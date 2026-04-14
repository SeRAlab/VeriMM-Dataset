module top_module (
	input p, 
	input q, 
	input r, 
	input s,
	output reg o);assign o = p&~q | r&~s | ~p&s;

endmodule