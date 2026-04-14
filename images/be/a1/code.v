module top_module(A, B, Cin, Sum, Cout);input A, B, Cin;
output Sum, Cout;

wire w1, w2, w3;

// First XOR gate
xor(w1, A, B);

// Second XOR gate
xor(Sum, w1, Cin);

// First AND gate
and(w2, A, B);

// Second AND gate
and(w3, Cin, w1);

// Third AND gate
and(Cout, w2, w3);

endmodule