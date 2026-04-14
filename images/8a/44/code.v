module top_module (
	input p, 
	input q, 
	input r, 
	input s,
	output reg z);assign z = p&~q | ~p&r | s&~p;

endmodule