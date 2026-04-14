module matrix_mult (
    input [3:0] A00, A01, // First row of first matrix
    input [3:0] A10, A11, // Second row of first matrix
    input [3:0] B00, B01, // First row of second matrix
    input [3:0] B10, B11, // Second row of second matrix
    output [3:0] C00, C01, // First row of result matrix
    output [3:0] C10, C11  // Second row of result matrix
);
    // Matrix multiplication
    assign C00 = A00 * B00 + A01 * B10; // C[0][0]
    assign C01 = A00 * B01 + A01 * B11; // C[0][1]
    assign C10 = A10 * B00 + A11 * B10; // C[1][0]
    assign C11 = A10 * B01 + A11 * B11; // C[1][1]
endmodule