module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output Cout,
    output [3:0] S
);wire w1, w2, w3, w4, w5;

// Full Adder for bit 0
xor(w1, A[0], B[0]);
xor(S[0], w1, Cin);
and(w2, w1, Cin);
or(Cout, A[0] & B[0], w2);

// Full Adder for bit 1
xor(w3, A[1], B[1]);
xor(S[1], w3, w2);
and(w4, w3, w2);
or(w5, A[1] & B[1], w4);
or(Cout, Cout, w5);

// Full Adder for bit 2
xor(w1, A[2], B[2]);
xor(S[2], w1, w4);
and(w2, w1, w4);
or(w3, A[2] & B[2], w2);
or(Cout, Cout, w3);

// Full Adder for bit 3
xor(w4, A[3], B[3]);
xor(S[3], w4, w2);
and(Cout, w4, w2);

endmodule