module matrix_multiplier (
    input [3:0] A11, A12, // Row 1 of matrix A
    input [3:0] A21, A22, // Row 2 of matrix A
    input [3:0] B11, B12, // Row 1 of matrix B
    input [3:0] B21, B22, // Row 2 of matrix B
    output [7:0] C11, C12, // Row 1 of matrix C
    output [7:0] C21, C22  // Row 2 of matrix C
);
    assign C11 = A11 * B11 + A12 * B21; // C[0][0]
    assign C12 = A11 * B12 + A12 * B22; // C[0][1]
    assign C21 = A21 * B11 + A22 * B21; // C[1][0]
    assign C22 = A21 * B12 + A22 * B22; // C[1][1]
endmodule