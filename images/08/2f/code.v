module matrix_multiply (
    input [7:0] A11, A12, A21, A22, // Elements of Matrix A
    input [7:0] B11, B12, B21, B22, // Elements of Matrix B
    output [7:0] C11, C12, C21, C22  // Elements of Resulting Matrix C
);
    assign C11 = A11 * B11 + A12 * B21; // C11 = A11*B11 + A12*B21
    assign C12 = A11 * B12 + A12 * B22; // C12 = A11*B12 + A12*B22
    assign C21 = A21 * B11 + A22 * B21; // C21 = A21*B11 + A22*B21
    assign C22 = A21 * B12 + A22 * B22; // C22 = A21*B12 + A22*B22
endmodule