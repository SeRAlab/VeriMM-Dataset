module graph_coloring(
    input [7:0] adj_matrix, // Adjacency matrix for a simple graph (max 4 vertices)
    input [2:0] num_colors,  // Number of colors available (1 to 7)
    output reg is_colorable   // Output flag for colorability
);
    integer i, j;

    always @(*) begin
        is_colorable = 1; // Assume it's colorable initially
        for (i = 0; i < 4; i = i + 1) begin
            for (j = i + 1; j < 4; j = j + 1) begin
                if (adj_matrix[i * 4 + j] && (i % num_colors == j % num_colors)) begin
                    is_colorable = 0; // Found an adjacent pair with the same color
                end
            end
        end
    end
endmodule