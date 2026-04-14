module sr_latch_nand(
	input 	S,
	input 	R,
	output Q,
	output Qn
);

wire n1, n2;

assign n1 = ~(S & Qn);
assign n2 = ~(R & Q);

assign Q = n1;
assign Qn = n2;

endmodule