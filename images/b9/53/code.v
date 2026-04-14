module top_module(
    OUT,
    A,
    B,
    SEL
);output OUT;
    input A;
    input B;
    input SEL;

    wire NOT_SEL;

    assign NOT_SEL = ~SEL;

    assign OUT = (A & NOT_SEL) | (B & SEL);

endmodule