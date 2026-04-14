module top_module(
    input A,
    input B,
    output Y
);assign Y = (B == 1) ? A : ((B == 0) ? B : 0);

endmodule