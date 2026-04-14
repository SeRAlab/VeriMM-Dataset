module matrix_inversion (
    input [15:0] matrix, // 4-bit each for a, b, c, d
    output reg [15:0] inverted_matrix // 4-bit each for a_inv, b_inv, c_inv, d_inv
);

    wire signed [7:0] a, b, c, d;
    wire signed [15:0] det;
    assign a = matrix[15:12]; // First element
    assign b = matrix[11:8];  // Second element
    assign c = matrix[7:4];   // Third element
    assign d = matrix[3:0];   // Fourth element

    assign det = (a * d) - (b * c);

    always @(*) begin
        if (det == 0) begin
            inverted_matrix = 16'b0000000000000000; // Output zero matrix
        end else begin
            inverted_matrix[15:12] = d / det;           // a_inv
            inverted_matrix[11:8]  = -b / det;          // b_inv
            inverted_matrix[7:4]   = -c / det;          // c_inv
            inverted_matrix[3:0]   = a / det;            // d_inv
        end
    end
endmodule