module top_module(
    input A,
    input B,
    input sel,
    output Y
);assign Y = (!sel & A) | (sel & B);

endmodule