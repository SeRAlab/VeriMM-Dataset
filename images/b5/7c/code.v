module conditional_logic (
	input p,
	input q,
	input r,
	input s,
	output reg x);assign x = p&~q&r&~s | ~p&q&~r&~s | p&q&~r&s | p&~q&~r&s | p&q&r&~s;

endmodule