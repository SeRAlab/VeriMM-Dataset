module mux_2to1 (
    Y,
    A,
    B,
    S
);

    output Y;
    input A, B, S;

    wire notS;
    assign notS = ~S;

    assign Y = (A & notS) | (B & S);

endmodule