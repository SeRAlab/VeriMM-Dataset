module mixed_logic (
	input p,
	input q,
	input r,
	input s,
	output reg t);assign t = ~p&~q&r&~s | p&~q&~r&s | ~p&q&r&s | p&q&~r&~s | ~p&q&~r&~s;

endmodule