module top_module(A, B, select, AOut, BOut);input [63:0] A, B;
	input [1:0] select;
	output [63:0] AOut, BOut;
	
	assign AOut = select[0] ? ~A : A;
	assign BOut = select[1] ? ~B : B;endmodule