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

    assign X = (A & B) | (C & D);

endmodule