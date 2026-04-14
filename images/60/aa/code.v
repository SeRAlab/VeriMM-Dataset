module top_module(
	input  D0, D1, D2, D3,
	input  D4, D5, D6, D7,
	input  S0, S1, S2,
	output Y
);assign Y = S2 ? (S1 ? (S0 ? D7 : D6) :
						  (S0 ? D5 : D4)) :
					(S1 ? (S0 ? D3 : D2) :
						  (S0 ? D1 : D0));

endmodule