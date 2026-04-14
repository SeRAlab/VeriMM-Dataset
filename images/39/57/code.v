module graph_coloring (
    input [3:0] vertices, // binary representation of vertices (4 bits)
    input [15:0] adj_matrix, // 4x4 adjacency matrix (16 bits)
    output reg [3:0] colors // 4 bits for 4 vertices
);
    integer i, j;

    always @(*) begin
        // Initialize colors
        colors = 4'b00;
        // Simple greedy coloring algorithm
        for (i = 0; i < 4; i = i + 1) begin
            colors[i] = 2'b00; // Start with color 0
            for (j = 0; j < 4; j = j + 1) begin
                if (adj_matrix[i * 4 + j] == 1 && colors[j] == colors[i]) begin
                    colors[i] = colors[i] + 1; // Increment color if adjacent and same color
                end
            end
        end
    end
endmodule