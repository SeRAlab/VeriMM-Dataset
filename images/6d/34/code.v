module top_module(
	input	[3:0]	D,
	input	[3:0]	T,
	input			cin,
	output	[3:0]	C
);assign	C[0] = D[0] | T[0]&cin;
	assign	C[1] = D[1] | T[1]&C[0];
	assign	C[2] = D[2] | T[2]&C[1];
	assign	C[3] = D[3] | T[3]&C[2];endmodule