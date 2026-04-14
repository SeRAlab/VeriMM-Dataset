module custom_or_gate (
    input A,
    input B,
    input C_N,
    output X
);

wire or_output;
not inv_C_N(C, C_N);

or or_gate (
    .X(or_output),
    .A(A),
    .B(B)
);

and and_gate (
    .X(X),
    .A(or_output),
    .B(C)
);

endmodule