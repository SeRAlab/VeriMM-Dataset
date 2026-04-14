module top_module(
    A,
    B,
    C,
    D,
    E,
    F
);input A;
    input B;
    input C;
    input D;
    input E;
    output F;

    assign F = (A == 1) && (B == 0) && (C == 1) && (D == 0) && (E == 1);

endmodule