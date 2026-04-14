module top_module(
    input A,
    input B,
    input C_N,
    output Y
);assign Y = ~(A | B | C_N);

endmodule