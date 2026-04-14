module custom_logic_t (
	input m,
	input n,
	input o,
	input p,
	output reg t);

assign t = m&~n&~o&~p | ~m&n&~o&~p | ~m&~n&o&~p | m&n&o&~p;

endmodule