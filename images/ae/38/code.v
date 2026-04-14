module decoder_2to4 (
	input a,
	input b,
	output d0,
	output d1,
	output d2,
	output d3);assign d0 = ~a & ~b;
assign d1 = ~a & b;
assign d2 = a & ~b;
assign d3 = a & b;

endmodule