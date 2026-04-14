module matrix_mult (
    input [3:0] a11, a12, // First row of first matrix
    input [3:0] a21, a22, // Second row of first matrix
    input [3:0] b11, b12, // First row of second matrix
    input [3:0] b21, b22, // Second row of second matrix
    output [3:0] c11, c12, // First row of result matrix
    output [3:0] c21, c22  // Second row of result matrix
);
    assign c11 = a11 * b11 + a12 * b21; // Element (1,1)
    assign c12 = a11 * b12 + a12 * b22; // Element (1,2)
    assign c21 = a21 * b11 + a22 * b21; // Element (2,1)
    assign c22 = a21 * b12 + a22 * b22; // Element (2,2)
endmodule