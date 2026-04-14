module LU_Decomposition (
    input [7:0] a11, a12,
    input [7:0] a21, a22,
    output [7:0] l11, l12,
    output [7:0] l21, l22,
    output [7:0] u11, u12,
    output [7:0] u21, u22
);
    assign l11 = 8'd1; // L11 = 1
    assign l12 = 8'd0; // L12 = 0
    assign l21 = a21;  // L21 = A21
    assign l22 = (a22 - (l21 * u12)) / l11; // L22 = A22 - L21 * U12 / L11

    assign u11 = a11; // U11 = A11
    assign u12 = a12; // U12 = A12
    assign u21 = 8'd0; // U21 = 0
    assign u22 = a22 - (l21 * u12); // U22 = A22 - L21 * U12

endmodule