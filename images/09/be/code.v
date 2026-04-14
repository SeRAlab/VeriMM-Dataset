module matrix_inverse (
    input [15:0] matrix_in, // 2x2 matrix as a flat 16-bit input
    output reg [15:0] matrix_out // 2x2 matrix as a flat 16-bit output
);
    wire signed [7:0] a, b, c, d;
    wire signed [15:0] det;

    // Split the input into the matrix elements
    assign a = matrix_in[15:12]; // First row, first column
    assign b = matrix_in[11:8];   // First row, second column
    assign c = matrix_in[7:4];    // Second row, first column
    assign d = matrix_in[3:0];    // Second row, second column

    // Calculate determinant
    assign det = (a * d) - (b * c);

    always @(*) begin
        if (det == 0) begin
            // Output a predefined value when the matrix is not invertible
            matrix_out = 16'h0000; // All zeros
        end else begin
            // Calculate the inverse
            matrix_out[15:12] = d / det;     // Inverse element (1,1)
            matrix_out[11:8]  = -b / det;    // Inverse element (1,2)
            matrix_out[7:4]   = -c / det;     // Inverse element (2,1)
            matrix_out[3:0]   = a / det;      // Inverse element (2,2)
        end
    end
endmodule