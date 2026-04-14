module LU_Decomposition(
    input [7:0] a11, a12,
    input [7:0] a21, a22,
    output reg [7:0] l11, l12, l21, l22,
    output reg [7:0] u11, u12, u21, u22
);
    always @* begin
        // LU decomposition for 2x2 matrix
        l11 = a11;           // L11 = A11
        l12 = a12;           // L12 = A12
        l21 = a21 * l11 / a11; // L21 = A21 / A11
        l22 = a22 - l21 * u12; // L22 = A22 - L21 * U12

        // For U matrix
        u11 = a11;           // U11 = A11
        u12 = a12;          // U12 = A12
        u21 = 0;            // U21 = 0
        u22 = a22 - (l21 * u12); // U22 = A22 - L21 * U12
    end
endmodule