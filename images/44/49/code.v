module top_module(
    input A,
    input B,
    input SEL,
    output Y
);wire sel_inv;
    assign sel_inv = ~SEL;

    assign Y = (A & sel_inv) | (B & SEL);

endmodule