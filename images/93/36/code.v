module top_module(
    input A,
    input B,
    input SEL,
    output OUT
);assign OUT = (SEL == 1'b0) ? A : B;

endmodule