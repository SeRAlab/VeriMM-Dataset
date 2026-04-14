module top_module(D, CP, SD, Q, QN);output Q;
	output QN;
	input D;
	input CP;
	input SD;

	wire QN;
	reg Q;
	wire D;
	wire CP;
	wire SD;

	always @(posedge CP)
		Q <= SD ? 0 : D;
	assign QN = ~Q;endmodule