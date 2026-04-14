module matrix_mult(
    input [3:0] a11, a12, // Row 1 of Matrix A
    input [3:0] a21, a22, // Row 2 of Matrix A
    input [3:0] b11, b12, // Row 1 of Matrix B
    input [3:0] b21, b22, // Row 2 of Matrix B
    output [7:0] c11, c12, // Row 1 of Matrix C (Result)
    output [7:0] c21, c22  // Row 2 of Matrix C (Result)
);
    assign c11 = a11 * b11 + a12 * b21; // C[1,1] = A[1,1] * B[1,1] + A[1,2] * B[2,1]
    assign c12 = a11 * b12 + a12 * b22; // C[1,2] = A[1,1] * B[1,2] + A[1,2] * B[2,2]
    assign c21 = a21 * b11 + a22 * b21; // C[2,1] = A[2,1] * B[1,1] + A[2,2] * B[2,1]
    assign c22 = a21 * b12 + a22 * b22; // C[2,2] = A[2,1] * B[1,2] + A[2,2] * B[2,2]
endmodule