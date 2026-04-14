module MatrixFactorization(
    input [15:0] interaction_matrix, // 4 values (2x2)
    output reg [15:0] user_matrix,    // 4 values (2x2)
    output reg [15:0] item_matrix      // 4 values (2x2)
);

reg [7:0] factor; // This will be a simple factor used in the factorization

always @(*) begin
    factor = 8'd2; // A simple scaling factor for demonstration
    user_matrix = {interaction_matrix[15:12] * factor, interaction_matrix[11:8] * factor}; // Row 1
    item_matrix = {interaction_matrix[7:4] * factor, interaction_matrix[3:0] * factor}; // Row 2
end

endmodule