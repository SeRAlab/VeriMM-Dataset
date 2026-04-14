module top_module(
    input A,
    input B,
    output Y0,
    output Y1,
    output Y2,
    output Y3
);wire notA, notB;
    wire AB, ABnot;

    // Invert A and B
    not(A, notA);
    not(B, notB);

    // AND gates
    and(notA, notB, Y0);
    and(notA, B, Y1);
    and(A, notB, Y2);
    and(A, B, Y3);

    // OR gates
    or(Y0, Y1, AB);
    or(Y2, Y3, ABnot);

    // NOT gates
    not(AB, Y2);
    not(ABnot, Y1);
endmodule