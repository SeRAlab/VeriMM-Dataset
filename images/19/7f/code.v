module LU_Decomposition (
    input [7:0] a11, a12,
    input [7:0] a21, a22,
    output [7:0] l11, l12, l21, l22,
    output [7:0] u11, u12, u21, u22
);
    assign l11 = 8'h1; // L(1,1) = 1
    assign l12 = 8'h0; // L(1,2) = 0
    assign l21 = a21 / a11; // L(2,1) = A(2,1) / A(1,1)
    assign l22 = 8'h1; // L(2,2) = 1

    assign u11 = a11; // U(1,1) = A(1,1)
    assign u12 = a12; // U(1,2) = A(1,2)
    assign u21 = 8'h0; // U(2,1) = 0
    assign u22 = a22 - l21 * u12; // U(2,2) = A(2,2) - L(2,1) * U(1,2)
endmodule