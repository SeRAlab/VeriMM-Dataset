module my_and4 (
    input A,
    input B,
    input C,
    input D,
    output reg X
);

    wire AB;
    wire CD;
    wire ABCD;

    // AND gate for A and B
    and gate_AB (
        .a(A),
        .b(B),
        .o(AB)
    );

    // AND gate for C and D
    and gate_CD (
        .a(C),
        .b(D),
        .o(CD)
    );

    // AND gate for AB and CD
    and gate_ABCD (
        .a(AB),
        .b(CD),
        .o(ABCD)
    );

    // NOT gate for ABCD
    not gate_X (
        .a(ABCD),
        .o(X)
    );

endmodule