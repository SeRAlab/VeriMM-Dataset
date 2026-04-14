module matrix_multiplier (
    input [7:0] A11, A12, A21, A22, // A[0][0], A[0][1], A[1][0], A[1][1]
    input [7:0] B11, B12, B21, B22, // B[0][0], B[0][1], B[1][0], B[1][1]
    output [15:0] C11, C12, C21, C22 // C[0][0], C[0][1], C[1][0], C[1][1]
);
    assign C11 = A11 * B11 + A12 * B21; // C[0][0]
    assign C12 = A11 * B12 + A12 * B22; // C[0][1]
    assign C21 = A21 * B11 + A22 * B21; // C[1][0]
    assign C22 = A21 * B12 + A22 * B22; // C[1][1]
endmodule