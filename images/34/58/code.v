module graph_coloring (
    input [4:0] edges, // Each bit represents an edge between nodes 0-4
    output reg [4:0] colors // Colors assigned to nodes 0-4
);
    integer i, j;
    reg [4:0] temp_colors;
    
    always @(*) begin
        colors = 5'b00000; // Initialize colors
        temp_colors = 5'b00000; // Temporary colors
        
        for (i = 0; i < 5; i = i + 1) begin
            if (colors[i] == 0) begin // If the node is not colored
                temp_colors = colors; // Copy current colors
                
                // Try coloring with different colors
                for (j = 1; j < 5; j = j + 1) begin
                    if (edges[(i * 5) + j] == 1 && colors[j] == j) begin
                        temp_colors[i] = j; // Assign color if adjacent node is not the same
                    end
                end
                colors[i] = temp_colors[i];
            end
        end
    end
endmodule