module top_module(
    input A,
    input B,
    input C,
    input D,
    input S0,
    input S1,
    output Y
);wire notS0, notS1;

    assign notS0 = ~S0;
    assign notS1 = ~S1;

    wire AB, CD;

    assign AB = S0 & notS1;
    assign CD = notS0 & S1;

    assign Y = (A & notS0 & notS1) | (B & AB) | (C & CD) | (D & S0 & S1);

endmodule