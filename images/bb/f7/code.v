module top_module(
    output Y,
    input A_N,
    input B_N,
    input C_N
);assign Y = ~(~A_N & ~B_N & ~C_N);
endmodule