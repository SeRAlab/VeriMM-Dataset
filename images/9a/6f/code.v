module top_module(A, B, andAB, orAB, xorAB);input [63:0] A, B;
	output [63:0] andAB, orAB, xorAB;
	
	assign andAB = A & B;
	assign orAB = A | B;
	assign xorAB = A ^ B;endmodule