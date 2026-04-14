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

    // Compute the output signal
    assign Y = (A & notS1 & notS0) |
               (B & notS1 & S0) |
               (C & S1 & notS0) |
               (D & S1 & S0);

endmodule