module LU_Decomposition(
    input [3:0] a,  // Element a11
    input [3:0] b,  // Element a12
    input [3:0] c,  // Element a21
    input [3:0] d,  // Element a22
    output [3:0] l11, // L11
    output [3:0] l21, // L21
    output [3:0] u11, // U11
    output [3:0] u12, // U12
    output [3:0] u22  // U22
);
    assign l11 = a;
    assign l21 = c / l11;  // L21 = A21 / L11
    assign u11 = l11;      // U11 = L11
    assign u12 = b;        // U12 = A12
    assign u22 = d - (l21 * u12); // U22 = A22 - L21 * U12
endmodule