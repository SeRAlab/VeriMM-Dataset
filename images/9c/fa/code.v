module sr_latch (
	input S,
	input R,
	output Q,
	output Q_bar);assign Q = ~(R & Q_bar);
assign Q_bar = ~(S & Q);
endmodule