module graph_coloring (
    input [7:0] adj_matrix, // 8-bit adjacency matrix for 4 vertices (4x4)
    output reg [3:0] colors  // 2-bit color for each of the 4 vertices
);
    always @(*) begin
        // Initialize colors
        colors = 4'b0000; // Start with all vertices uncolored
        
        // Simple bipartite coloring
        // If adjacent vertices are connected, color them differently
        if (adj_matrix[0] || adj_matrix[1]) begin
            colors[0] = 1; // Color vertex 0 with color 1
            colors[1] = 0; // Color vertex 1 with color 0
        end
        if (adj_matrix[2] || adj_matrix[3]) begin
            colors[2] = 1; // Color vertex 2 with color 1
            colors[3] = 0; // Color vertex 3 with color 0
        end
    end
endmodule