module top_module(RN, SN, CK, D, Q, QN);input RN;
	input SN;
	input CK;
	input D;
	output Q;
	output QN;

	wire RN;
	wire SN;
	wire CK;
	wire D;
	reg Q;
	wire QN;

	always @(posedge CK or negedge SN or negedge RN)
		if (!SN)
			Q <= 1;
		else if (!RN)
			Q <= 0;
		else
			Q <= D;
	assign QN = Q;endmodule