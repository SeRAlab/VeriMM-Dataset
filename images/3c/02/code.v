module matrix_mult (
    input [3:0] a11, a12, // First row of matrix A
    input [3:0] a21, a22, // Second row of matrix A
    input [3:0] b11, b12, // First row of matrix B
    input [3:0] b21, b22, // Second row of matrix B
    output [7:0] c11, c12, // First row of resulting matrix C
    output [7:0] c21, c22  // Second row of resulting matrix C
);
    assign c11 = a11 * b11 + a12 * b21; // C[0][0]
    assign c12 = a11 * b12 + a12 * b22; // C[0][1]
    assign c21 = a21 * b11 + a22 * b21; // C[1][0]
    assign c22 = a21 * b12 + a22 * b22; // C[1][1]
endmodule