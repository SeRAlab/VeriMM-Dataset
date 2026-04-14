module matrix_mult (
    input [31:0] A11, A12, A21, A22, // Elements of matrix A
    input [31:0] B11, B12, B21, B22, // Elements of matrix B
    output [31:0] C11, C12, C21, C22  // Elements of matrix C (result)
);
    assign C11 = A11 * B11 + A12 * B21; // C[0][0]
    assign C12 = A11 * B12 + A12 * B22; // C[0][1]
    assign C21 = A21 * B11 + A22 * B21; // C[1][0]
    assign C22 = A21 * B12 + A22 * B22; // C[1][1]
endmodule