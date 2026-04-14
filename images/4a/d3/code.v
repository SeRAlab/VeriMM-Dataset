module top_module (
	input p, 
	input q, 
	input r, 
	input s,
	output reg n);assign n = p^q | ~r&s | ~p&q;

endmodule