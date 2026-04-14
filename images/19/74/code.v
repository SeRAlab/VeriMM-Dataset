module matrix_mult (
    input [3:0] a11, a12, // First matrix row 1
    input [3:0] a21, a22, // First matrix row 2
    input [3:0] b11, b12, // Second matrix row 1
    input [3:0] b21, b22, // Second matrix row 2
    output [7:0] c11, c12, // Result matrix row 1
    output [7:0] c21, c22  // Result matrix row 2
);
    assign c11 = a11 * b11 + a12 * b21; // Element (1,1)
    assign c12 = a11 * b12 + a12 * b22; // Element (1,2)
    assign c21 = a21 * b11 + a22 * b21; // Element (2,1)
    assign c22 = a21 * b12 + a22 * b22; // Element (2,2)
endmodule