module matrix_multiplier (
    input [7:0] A11, A12, A21, A22, // Elements of matrix A
    input [7:0] B11, B12, B21, B22, // Elements of matrix B
    output [15:0] C11, C12, C21, C22 // Elements of result matrix C
);
    assign C11 = A11 * B11 + A12 * B21; // Element C11
    assign C12 = A11 * B12 + A12 * B22; // Element C12
    assign C21 = A21 * B11 + A22 * B21; // Element C21
    assign C22 = A21 * B12 + A22 * B22; // Element C22
endmodule