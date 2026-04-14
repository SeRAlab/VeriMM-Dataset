module top_module(
    input A,
    input B,
    input C,
    input D,
    output parity
);wire ab, cd, abcd;

    xor(ab, A, B);
    xor(cd, C, D);
    xor(abcd, ab, cd);
    assign parity = abcd;

endmodule