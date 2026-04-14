module matrix_mult_2x2 (
    input [3:0] a11, a12,  // First matrix elements
    input [3:0] a21, a22,  
    input [3:0] b11, b12,  // Second matrix elements
    input [3:0] b21, b22,
    output [7:0] c11, c12, // Result matrix elements
    output [7:0] c21, c22
);
    assign c11 = a11 * b11 + a12 * b21; // c11 = a11*b11 + a12*b21
    assign c12 = a11 * b12 + a12 * b22; // c12 = a11*b12 + a12*b22
    assign c21 = a21 * b11 + a22 * b21; // c21 = a21*b11 + a22*b21
    assign c22 = a21 * b12 + a22 * b22; // c22 = a21*b12 + a22*b22
endmodule