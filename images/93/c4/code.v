module top_module(
    input A1_N,
    input A2_N,
    input B1,
    input B2,
    output Y
);assign Y = ((A1_N & A2_N) | (B1 & B2)) ? 0 :
               ((A1_N & ~B1) | (A2_N & ~B2)) ? 0 : 1;

endmodule