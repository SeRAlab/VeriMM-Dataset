module LU_Decomposition (
    input [7:0] a11, a12,
    input [7:0] a21, a22,
    output [7:0] l11, l12, l21, l22,
    output [7:0] u11, u12, u21, u22
);
    // Intermediate variables
    wire [7:0] u21;

    // LU Decomposition calculations
    assign l11 = a11;
    assign l12 = 0; // L is lower triangular
    assign l21 = a21 / a11; // l21 = a21 / a11
    assign l22 = a22 - l21 * a12; // l22 = a22 - l21 * a12

    assign u11 = a11; // U is upper triangular
    assign u12 = a12; // u12 = a12
    assign u21 = 0; // u21 = 0
    assign u22 = l22; // u22 = l22

endmodule