module and_gate (
    Y,
    A,
    B,
    C
);

    output Y;
    input A;
    input B;
    input C;

    assign Y = (A & B & ~C);

endmodule