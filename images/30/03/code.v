module LU_Decomposition (
    input [15:0] a11, a12,
    input [15:0] a21, a22,
    output [15:0] l11, l21, l22,
    output [15:0] u11, u12, u22
);
    // Calculate the elements of L and U
    assign l11 = a11;
    assign l21 = a21 / l11;  // assuming l11 is not zero
    assign l22 = 0;          // lower triangular has zeros above the diagonal

    assign u11 = a11;        
    assign u12 = a12;        
    assign u22 = a22 - l21 * u12; // calculation for the U matrix element
endmodule