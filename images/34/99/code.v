module matrix_multiply (
    input [7:0] A11, A12, A21, A22, // First 2x2 matrix
    input [7:0] B11, B12, B21, B22, // Second 2x2 matrix
    output [7:0] C11, C12, C21, C22  // Resultant 2x2 matrix
);
    assign C11 = A11 * B11 + A12 * B21; // C[0][0] = A[0][0] * B[0][0] + A[0][1] * B[1][0]
    assign C12 = A11 * B12 + A12 * B22; // C[0][1] = A[0][0] * B[0][1] + A[0][1] * B[1][1]
    assign C21 = A21 * B11 + A22 * B21; // C[1][0] = A[1][0] * B[0][0] + A[1][1] * B[1][0]
    assign C22 = A21 * B12 + A22 * B22; // C[1][1] = A[1][0] * B[0][1] + A[1][1] * B[1][1]
endmodule