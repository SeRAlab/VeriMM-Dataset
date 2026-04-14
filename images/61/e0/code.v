module top_module(
    input A,
    input B,
    input C,
    output Y0,
    output Y1,
    output Y2,
    output Y3,
    output Y4,
    output Y5,
    output Y6,
    output Y7
);wire notA, notB, notC;
    wire and0, and1, and2, and3, and4, and5, and6, and7;

    // Negation of inputs
    not U1 (notA, A);
    not U2 (notB, B);
    not U3 (notC, C);

    // AND gates
    and U4 (and0, notA, notB, notC);
    and U5 (and1, notA, notB, C);
    and U6 (and2, notA, B, notC);
    and U7 (and3, notA, B, C);
    and U8 (and4, A, notB, notC);
    and U9 (and5, A, notB, C);
    and U10 (and6, A, B, notC);
    and U11 (and7, A, B, C);

    // Outputs
    assign Y0 = and0;
    assign Y1 = and1;
    assign Y2 = and2;
    assign Y3 = and3;
    assign Y4 = and4;
    assign Y5 = and5;
    assign Y6 = and6;
    assign Y7 = and7;

endmodule