module top_module(
    input A,
    input B,
    input SEL,
    output X
);wire not_sel;
    wire and1, and2;
    wire or1;

    assign not_sel = ~SEL;
    assign and1 = A & not_sel;
    assign and2 = B & SEL;
    assign or1 = and1 | and2;
    assign X = or1;

endmodule