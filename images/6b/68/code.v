module top_module(
    input A,
    input B,
    output Z
);assign Z = ~(A | B);

endmodule