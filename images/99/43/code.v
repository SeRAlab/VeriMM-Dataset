module top_module(
    input [3:0] A,
    input [3:0] B,
    input C_in,
    output [3:0] S,
    output C_out
);wire c1, c2, c3;

    // First column
    assign S[0] = A[0] ^ B[0] ^ C_in;
    assign c1 = (A[0] & B[0]) | (C_in & (A[0] ^ B[0]));

    // Second column
    assign S[1] = A[1] ^ B[1] ^ c1;
    assign c2 = (A[1] & B[1]) | (c1 & (A[1] ^ B[1]));

    // Third column
    assign S[2] = A[2] ^ B[2] ^ c2;
    assign c3 = (A[2] & B[2]) | (c2 & (A[2] ^ B[2]));

    // Fourth column
    assign S[3] = A[3] ^ B[3] ^ c3;
    assign C_out = (A[3] & B[3]) | (c3 & (A[3] ^ B[3]));

endmodule