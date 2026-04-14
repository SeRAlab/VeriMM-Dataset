module top_module(
    A,
    B,
    C,
    D,
    X
);input A;
    input B;
    input C;
    input D;
    output X;

    wire and0_out;
    wire and1_out;

    and and0 (and0_out, A, B);
    and and1 (and1_out, C, D);
    and and2 (X, and0_out, and1_out);

endmodule