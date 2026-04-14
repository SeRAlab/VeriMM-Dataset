module matrix_multiply (
    input [3:0] A11, A12, A21, A22, // Elements of matrix A
    input [3:0] B11, B12, B21, B22, // Elements of matrix B
    output reg [3:0] C11, C12, C21, C22 // Elements of output matrix C
);
    always @* begin
        C11 = A11 * B11 + A12 * B21; // C11
        C12 = A11 * B12 + A12 * B22; // C12
        C21 = A21 * B11 + A22 * B21; // C21
        C22 = A21 * B12 + A22 * B22; // C22
    end
endmodule