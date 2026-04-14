module top_module(
	input  A,
	input  B,
	input Cin,
	output C
    );assign G = A&B;
	assign P = A^B;
	assign C = G | (P & Cin);
	
endmodule