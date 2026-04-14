module matrix_factorization (
    input wire [3:0] matrix_input, // 2x2 matrix as a single input
    output wire [1:0] output_row,   // 1x2 output
    output wire [1:0] output_col    // 2x1 output
);
    wire [1:0] a = matrix_input[3:2]; // First row
    wire [1:0] b = matrix_input[1:0]; // Second row

    // Simple factorization logic for demonstration
    assign output_row = a;         // Row output
    assign output_col = b;         // Column output
endmodule