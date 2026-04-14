module LU_Decomposition(
    input [7:0] a11, a12,
    input [7:0] a21, a22,
    output [7:0] l11, l12, l21, l22,
    output [7:0] u11, u12, u21, u22
);
    // Implementation of LU Decomposition for 2x2 matrix
    assign l11 = a11;
    assign l12 = 0;
    assign l21 = a21 / a11; // assuming a11 != 0
    assign l22 = a22 - l21 * a12;

    assign u11 = a11;
    assign u12 = a12;
    assign u21 = 0;
    assign u22 = l22;
endmodule