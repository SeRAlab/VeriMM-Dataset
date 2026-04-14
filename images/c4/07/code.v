module FA (
	input A, B, Cin,
	output S, Cout
);

	assign S = A ^ B ^ Cin;
	assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule

module four_bit_adder (
	input [3:0] A,
	input [3:0] B,
	input Cin,
	output [3:0] S,
	output Cout
);

	wire c0, c1, c2;

	FA fa0 (.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(c0));
	FA fa1 (.A(A[1]), .B(B[1]), .Cin(c0), .S(S[1]), .Cout(c1));
	FA fa2 (.A(A[2]), .B(B[2]), .Cin(c1), .S(S[2]), .Cout(c2));
	FA fa3 (.A(A[3]), .B(B[3]), .Cin(c2), .S(S[3]), .Cout(Cout));

endmodule