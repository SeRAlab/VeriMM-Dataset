module lu_decomposition(
    input [3:0] a11, input [3:0] a12,
    input [3:0] a21, input [3:0] a22,
    output [3:0] l11, output [3:0] l21,
    output [3:0] u11, output [3:0] u12, output [3:0] u22
);
    assign l11 = 1; // Lower triangular matrix L
    assign l21 = a21 / a11; // L21 = A21 / A11
    assign u11 = a11; // Upper triangular matrix U
    assign u12 = a12; // U12 = A12
    assign u22 = a22 - l21 * u12; // U22 = A22 - L21 * U12
endmodule