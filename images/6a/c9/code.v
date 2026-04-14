module top_module(
    input [3:0] A,
    input [3:0] B,
    input CI,
    output [3:0] S,
    output CO
);wire [4:0] C; // Increase size to accommodate carry out

    // Using a basic full adder implementation instead of ADDFX1
    assign S[0] = A[0] ^ B[0] ^ CI;
    assign C[0] = (A[0] & B[0]) | (CI & (A[0] ^ B[0]));
    
    assign S[1] = A[1] ^ B[1] ^ C[0];
    assign C[1] = (A[1] & B[1]) | (C[0] & (A[1] ^ B[1]));

    assign S[2] = A[2] ^ B[2] ^ C[1];
    assign C[2] = (A[2] & B[2]) | (C[1] & (A[2] ^ B[2]));

    assign S[3] = A[3] ^ B[3] ^ C[2];
    assign CO = (A[3] & B[3]) | (C[2] & (A[3] ^ B[3]));

endmodule