module top_module(
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
);wire w1, w2, w3;

    // First stage
    xor x1(Sum, A, B);
    and a1(w1, A, B);
    and a2(w2, A, Cin);
    and a3(w3, B, Cin);
    or o1(Cout, w1, w2, w3);

endmodule