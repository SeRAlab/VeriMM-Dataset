module three_input_gate (
    A,
    B,
    C,
    Y
);

    input A, B, C;
    output Y;

    wire and1, and2, and3;
    wire or1, or2;

    assign and1 = A & B;
    assign and2 = A & C;
    assign and3 = B & C;
    assign or1 = and1 | and2;
    assign or2 = or1 | and3;
    assign Y = or2;

endmodule