module top_module(
    A,
    B,
    C,
    D,
    X
);// Module ports
    input A;
    input B;
    input C;
    input D;
    output X;

    // Local signals
    wire not_A;
    wire not_B;
    wire not_C;
    wire not_D;
    wire nor_AB;
    wire nor_CD;
    wire nor_ABCD;

    // Implementing the AND gate using primitive gates
    not notA(not_A, A);
    not notB(not_B, B);
    not notC(not_C, C);
    not notD(not_D, D);

    nor norAB(nor_AB, not_A, not_B);
    nor norCD(nor_CD, not_C, not_D);

    nor norABCD(nor_ABCD, nor_AB, nor_CD);
    not notX(X, nor_ABCD);

endmodule