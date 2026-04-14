module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y
);wire not_A, not_B, not_C, not_D;
wire and_AB, and_CD;
wire or_ABCD;

not not_gate_A(not_A, A);
not not_gate_B(not_B, B);
not not_gate_C(not_C, C);
not not_gate_D(not_D, D);

and and_gate_AB(and_AB, A, B);
and and_gate_CD(and_CD, C, D);

or or_gate_ABCD(or_ABCD, and_AB, and_CD);

not not_gate_Y(Y, or_ABCD);

endmodule