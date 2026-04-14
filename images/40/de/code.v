module lu_decomposition (
    input [3:0] A,    // 2x2 matrix A represented as 4 bits (A[3:2] A[1:0])
    output [3:0] L,   // Lower triangular matrix L
    output [3:0] U    // Upper triangular matrix U
);
    wire [1:0] a11, a12, a21, a22;
    assign a11 = A[3:2]; // A11
    assign a12 = A[1:0]; // A12
    assign a21 = a11;    // L21 = A11
    assign a22 = a12;    // L22 = A12

    // L matrix
    assign L = {a21, a22}; // L = [[1, 0], [A11/A21, 1]]
    
    // U matrix
    assign U = {a11, a12 - a21}; // U = [[A11, A12], [0, A22 - (L21 * U11)]]
endmodule