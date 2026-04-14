module full_adder (
    input A,
    input B,
    input CIN,
    output S,
    output COUT
);

    assign S = A ^ B ^ CIN;
    assign COUT = (A & B) | (A & CIN) | (B & CIN);

endmodule

module four_bit_adder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output COUT
);

    wire [3:0] C;

    full_adder fa0(A[0], B[0], 0, S[0], C[0]);
    full_adder fa1(A[1], B[1], C[0], S[1], C[1]);
    full_adder fa2(A[2], B[2], C[1], S[2], C[2]);
    full_adder fa3(A[3], B[3], C[2], S[3], COUT);

endmodule