module matrix_factorization (
    input [15:0] matrix_in, // 2x2 matrix represented as 16-bit input
    output [15:0] matrix_out1, // first factorized matrix
    output [15:0] matrix_out2  // second factorized matrix
);
    // Intermediate variables
    wire [7:0] a, b, c, d;
    
    assign {a, b, c, d} = matrix_in; // unpack the 2x2 matrix

    // Factorization example (simple multiplication as placeholder)
    assign matrix_out1 = {a + b, c, d + b, a + c}; // Factorized matrix 1
    assign matrix_out2 = {a - b, c, d - b, a - c}; // Factorized matrix 2
endmodule