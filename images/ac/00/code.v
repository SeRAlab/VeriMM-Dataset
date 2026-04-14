module top_module(D, SI, SE, CLK, RSTB, Q, QN);output QN;
	output Q;
	input D;
	input SI;
	input SE;
	input CLK;
	input RSTB;

	wire QN;
	reg Q;
	wire D;
	wire SI;
	wire SE;
	wire CLK;
	wire RSTB;
	
	assign nQ = SE ? SI : D;

	always @(posedge CLK or negedge RSTB)
		if (!RSTB) Q <= 0;
		else Q <= nQ;
	
	assign QN = ~Q;endmodule