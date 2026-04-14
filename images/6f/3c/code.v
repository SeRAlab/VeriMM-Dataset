module full_adder (
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
);

wire w1, w2, w3;

xor (w1, A, B);
xor (Sum, w1, Cin);
and (w2, A, B);
and (w3, w1, Cin);
or (Cout, w2, w3);

endmodule