module LU_Decomposition (
    input [15:0] A, // 2x2 matrix input: A[15:0] = {a11, a12, a21, a22}
    output [15:0] L, // Lower triangular matrix
    output [15:0] U  // Upper triangular matrix
);
    wire [7:0] a11, a12, a21, a22;
    assign {a11, a12, a21, a22} = A;

    // Calculate U
    assign U[15:8] = {a11, a12}; // U11 = a11, U12 = a12
    assign U[7:0] = {a21 - (a12 * a21 / a11), a22 - (a12 * a22 / a11)}; // U21 and U22

    // Calculate L
    assign L[15:8] = {8'b00000000, a21 / a11}; // L21 = a21/a11
    assign L[7:0] = {8'b00000000, 8'b00000001}; // L11 = 1

endmodule