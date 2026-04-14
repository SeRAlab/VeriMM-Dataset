module top_module(
    Y,
    A1,
    A2,
    A3,
    A4,
    B1
);output Y;
    input A1;
    input A2;
    input A3;
    input A4;
    input B1;

    wire even;
    wire odd;

    assign even = (A1 ^ A2 ^ A3 ^ A4) == 0;
    assign odd = (A1 ^ A2 ^ A3 ^ A4) == 1;

    assign Y = (B1 == 0) ? even : odd;

endmodule