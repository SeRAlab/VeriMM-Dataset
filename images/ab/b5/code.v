module top_module(D, GN, Q, QN);output Q;
	output QN;
	input D;
	input GN;

	reg Q;
	wire QN;
	wire D;
	wire GN;

	always @(D or GN)
		if (~GN)
			Q <= D;

	assign QN = ~Q;endmodule