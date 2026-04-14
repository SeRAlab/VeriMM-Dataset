module top_module(
    input A,
    input B,
    output Y
);assign Y = (A & ~B) | (~A & B);

endmodule