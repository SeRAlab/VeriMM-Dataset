module LU_Decomposition (
    input [15:0] a11, a12,
    input [15:0] a21, a22,
    output [15:0] l11, l12, l21, l22,
    output [15:0] u11, u12, u21, u22
);
    assign l11 = a11;
    assign l12 = 0; // L12 is always 0 in 2x2 LU decomposition
    assign l21 = a21 / l11; // L21 = A21 / L11
    assign l22 = a22 - (l21 * u12); // L22 = A22 - (L21 * U12)

    assign u11 = a11; // U11 is A11
    assign u12 = a12; // U12 is A12
    assign u21 = 0; // U21 is always 0 in 2x2 LU decomposition
    assign u22 = a22 - (l21 * u12); // U22 = A22 - (L21 * U12)
endmodule