module matrix_multiplier (
    input [7:0] a11, a12,    // Elements of first matrix
    input [7:0] a21, a22,
    input [7:0] b11, b12,    // Elements of second matrix
    input [7:0] b21, b22,
    output [15:0] c11, c12,  // Elements of resultant matrix
    output [15:0] c21, c22
);
    assign c11 = a11 * b11 + a12 * b21; // Resultant matrix element c11
    assign c12 = a11 * b12 + a12 * b22; // Resultant matrix element c12
    assign c21 = a21 * b11 + a22 * b21; // Resultant matrix element c21
    assign c22 = a21 * b12 + a22 * b22; // Resultant matrix element c22
endmodule