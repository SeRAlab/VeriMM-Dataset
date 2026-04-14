module matrix_mult (
    input [7:0] A11, A12, A21, A22, // First matrix elements
    input [7:0] B11, B12, B21, B22, // Second matrix elements
    output [15:0] C11, C12, C21, C22 // Resulting matrix elements
);
    // Compute the product
    assign C11 = A11 * B11 + A12 * B21; // Resulting element C11
    assign C12 = A11 * B12 + A12 * B22; // Resulting element C12
    assign C21 = A21 * B11 + A22 * B21; // Resulting element C21
    assign C22 = A21 * B12 + A22 * B22; // Resulting element C22
endmodule