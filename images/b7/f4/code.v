module top_module(
    input A1,
    input A2,
    input B1_N,
    output Y
);assign Y = (A1 & A2 & ~B1_N) | (~A1 & ~A2 & ~B1_N);

endmodule