module top_module(
    input A,
    input B,
    input SEL,
    output Y
);assign Y = (SEL == 0) ? A : B;

endmodule