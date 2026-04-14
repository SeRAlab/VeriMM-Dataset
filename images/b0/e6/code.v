module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y
);// Replace the unknown module with a structural implementation of a 4-input NOR gate
    wire notA, notB, notC, notD;
    wire tmp1, tmp2;

    // Invert the inputs
    not U1(notA, A);
    not U2(notB, B);
    not U3(notC, C);
    not U4(notD, D);

    // NOR logic
    or U5(tmp1, notA, notB);
    or U6(tmp2, notC, notD);
    and U7(Y, tmp1, tmp2);

endmodule