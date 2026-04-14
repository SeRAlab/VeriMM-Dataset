module graph_coloring (
    input [15:0] edges, // 4x4 adjacency matrix
    output reg [3:0] colors // 2-bit color per node
);
    integer i, j;
    always @(*) begin
        // Initialize colors
        colors = 4'b0000;
        
        // Simple bipartite coloring
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                if (edges[i*4 + j] && colors[i] == colors[j]) begin
                    // If there's an edge and colors are the same, alternate colors
                    colors[j] = ~colors[i] & 1'b1; // flip color
                end
            end
        end
    end
endmodule