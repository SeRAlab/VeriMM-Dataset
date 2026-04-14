module LU_Decomposition (
    input [7:0] a11, a12, 
    input [7:0] a21, a22, 
    output [7:0] l11, l12, 
    output [7:0] u11, u12, u21, u22
);
    assign l11 = a11;                         // L[0][0] = A[0][0]
    assign l12 = a12 / l11;                   // L[0][1] = A[0][1] / L[0][0]
    assign u11 = a11;                         // U[0][0] = A[0][0]
    assign u12 = a12;                         // U[0][1] = A[0][1]
    assign u21 = a21;                         // U[1][0] = A[1][0]
    assign u22 = a22 - (l12 * u21);           // U[1][1] = A[1][1] - (L[0][1] * U[1][0])
endmodule