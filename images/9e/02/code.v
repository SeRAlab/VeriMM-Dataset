module custom_logic_y (
	input m,
	input n,
	input o,
	input p,
	output reg y);

assign y = ~m&n&~o&p | m&n&o&p | m&~n&~o&p | m&n&~o&~p;

endmodule