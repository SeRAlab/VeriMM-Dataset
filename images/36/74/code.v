module matrix_multiplier(
    input [7:0] A00, A01, A10, A11,  // Elements of matrix A
    input [7:0] B00, B01, B10, B11,  // Elements of matrix B
    output [15:0] C00, C01, C10, C11  // Elements of matrix C
);
    assign C00 = A00 * B00 + A01 * B10; // C[0][0]
    assign C01 = A00 * B01 + A01 * B11; // C[0][1]
    assign C10 = A10 * B00 + A11 * B10; // C[1][0]
    assign C11 = A10 * B01 + A11 * B11; // C[1][1]
endmodule