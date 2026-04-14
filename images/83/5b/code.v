module top_module (
	input p, 
	input q, 
	input r, 
	input s,
	output reg t);assign t = p | ~q^r | ~p&~s;

endmodule