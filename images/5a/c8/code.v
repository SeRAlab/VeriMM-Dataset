module top_module(
    input A,
    input B,
    input C,
    input D,
    input S0,
    input S1,
    output Y
);wire not_S0, not_S1;

    assign not_S0 = ~S0;
    assign not_S1 = ~S1;

    wire and1, and2, and3, and4;

    assign and1 = A & not_S1 & not_S0;
    assign and2 = B & not_S1 & S0;
    assign and3 = C & S1 & not_S0;
    assign and4 = D & S1 & S0;

    wire or1;

    assign or1 = and1 | and2 | and3 | and4;

    assign Y = ~(~or1);

endmodule