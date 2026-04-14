module LU_Decomposition (
    input [3:0] A, // 2x2 matrix [a, b, c, d]
    output [2:0] L, // Lower triangular matrix [l11, l21]
    output [4:0] U  // Upper triangular matrix [u11, u12, u22]
);
    wire a, b, c, d;
    assign a = A[3];
    assign b = A[2];
    assign c = A[1];
    assign d = A[0];

    // Calculate L and U
    assign L[2] = a; // l11 = a
    assign L[1] = c / a; // l21 = c / a
    assign U[4] = a; // u11 = a
    assign U[3] = b; // u12 = b
    assign U[2] = d - (L[1] * U[3]); // u22 = d - (l21 * u12)

endmodule