module matrix_multiplier (
    input [15:0] matrix_a,  // 4 elements for 2x2 matrix A
    input [15:0] matrix_b,  // 4 elements for 2x2 matrix B
    output [15:0] matrix_out // 4 elements for the resulting 2x2 matrix
);
    wire [7:0] a11, a12, a21, a22;
    wire [7:0] b11, b12, b21, b22;

    assign {a11, a12, a21, a22} = matrix_a;
    assign {b11, b12, b21, b22} = matrix_b;

    assign matrix_out[15:0] = {
        a11 * b11 + a12 * b21, // Output element (0,0)
        a11 * b12 + a12 * b22, // Output element (0,1)
        a21 * b11 + a22 * b21, // Output element (1,0)
        a21 * b12 + a22 * b22  // Output element (1,1)
    };
endmodule