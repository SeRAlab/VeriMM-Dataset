module matrix_factorization (
    input [3:0] A11, A12, A21, A22, // Elements of matrix A
    input [3:0] B11, B12, B21, B22, // Elements of matrix B
    output reg [7:0] C11, C12, C21, C22 // Elements of output matrix C
);
    always @* begin
        // Matrix multiplication C = A * B
        C11 = A11 * B11 + A12 * B21; // C[0][0]
        C12 = A11 * B12 + A12 * B22; // C[0][1]
        C21 = A21 * B11 + A22 * B21; // C[1][0]
        C22 = A21 * B12 + A22 * B22; // C[1][1]
    end
endmodule