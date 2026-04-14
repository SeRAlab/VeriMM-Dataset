module top_module(D, CP, CD, Q, QN);output Q;
	output QN;
	input D;
	input CP;
	input CD;

	wire QN;
	reg Q;
	wire D;
	wire CP;
	wire CD;

	always @(posedge CP)
		Q <= CD ? 0 : D;
	assign QN = ~Q;endmodule