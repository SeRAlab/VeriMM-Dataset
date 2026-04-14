module combinational_logic (
    Y,
    A1,
    A2,
    B1,
    B2,
    C1
);

    output Y;
    input A1, A2, B1, B2, C1;

    assign Y = (~A1 & B1 & C1) | (~A1 & ~B2 & ~C1) | (A1 & ~B1 & ~C1) | (A2 & ~B1 & ~C1) | (A2 & B2 & C1);

endmodule