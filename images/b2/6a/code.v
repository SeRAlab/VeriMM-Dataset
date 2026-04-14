module top_module(
    input A_N,
    input B,
    input VPWR,
    input VGND,
    output Y
);assign Y = ~(A_N & B);

endmodule