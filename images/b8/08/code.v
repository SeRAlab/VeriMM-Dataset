module top_module(
    input A,
    input B,
    input C,
    input D,
    input E,
    input F,
    input G,
    input H,
    output Y
);assign Y = (A & B & C) | (D & E & F & G) | H;

endmodule