module lu_decomposition (
    input [15:0] matrix_a, // 2x2 matrix represented as two 8-bit numbers
    output [15:0] lower,    // 2x2 lower triangular matrix
    output [15:0] upper     // 2x2 upper triangular matrix
);
    wire [7:0] a11, a12, a21, a22;
    assign a11 = matrix_a[15:8];
    assign a12 = matrix_a[7:0];

    // Calculate U
    assign upper[15:8] = a11;              // U11
    assign upper[7:0] = a12;                // U12

    // Calculate L
    assign lower[15:8] = (a11 == 0) ? 0 : (a21 * 8'hFF / a11);  // L21 = A21 / U11
    assign lower[7:0] = 8'hFF;              // L11 = 1 (in 8-bit format)

endmodule