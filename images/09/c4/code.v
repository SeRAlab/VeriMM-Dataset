module matrix_multiplier (
    input [7:0] a11, a12, a21, a22, // First matrix elements
    input [7:0] b11, b12, b21, b22, // Second matrix elements
    output reg [15:0] c11, c12, c21, c22 // Resulting matrix elements
);
    always @(*) begin
        // Matrix multiplication: C = A * B
        c11 = a11 * b11 + a12 * b21; // First row, first column
        c12 = a11 * b12 + a12 * b22; // First row, second column
        c21 = a21 * b11 + a22 * b21; // Second row, first column
        c22 = a21 * b12 + a22 * b22; // Second row, second column
    end
endmodule