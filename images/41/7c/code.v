module top_module(
    input A,
    input B,
    input EN,
    output Y
);assign Y = EN ? A : B;

endmodule