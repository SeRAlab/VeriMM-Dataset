module LU_Decomposition (
    input [15:0] A, // 2x2 matrix input represented as two 16-bit numbers
    output [15:0] L, // Lower triangular matrix
    output [15:0] U  // Upper triangular matrix
);
    wire [7:0] a11, a12, a21, a22;
    assign {a11, a12} = A[15:0]; // A[0] = a11, A[1] = a12
    assign {a21, a22} = A[31:16]; // A[2] = a21, A[3] = a22

    // Calculate U
    assign U[15:8] = a11; // U11 = a11
    assign U[7:0] = a12;  // U12 = a12

    // Calculate L
    assign L[15:8] = {8'b0}; // L21 = 0
    assign L[7:0] = a21 / a11; // L22 = a21 / a11

endmodule