module matrix_multiplier (
    input [3:0] A00, A01, A10, A11, // A[0][0], A[0][1], A[1][0], A[1][1]
    input [3:0] B00, B01, B10, B11, // B[0][0], B[0][1], B[1][0], B[1][1]
    output [3:0] C00, C01, C10, C11  // C[0][0], C[0][1], C[1][0], C[1][1]
);
    assign C00 = (A00 * B00) + (A01 * B10);
    assign C01 = (A00 * B01) + (A01 * B11);
    assign C10 = (A10 * B00) + (A11 * B10);
    assign C11 = (A10 * B01) + (A11 * B11);
endmodule