module graph_coloring(
    input [24:0] adj_matrix, // 5x5 adjacency matrix
    output reg [4:0] colors // colors for nodes 0-4
);
    
    integer i, j;
    reg [2:0] temp_color;

    always @(*) begin
        // Initialize colors to 0
        colors = 5'b00000;

        // Start coloring the nodes
        for (i = 0; i < 5; i = i + 1) begin
            // Pick the smallest color not used by adjacent nodes
            temp_color = 0;

            // Check adjacent nodes
            for (j = 0; j < 5; j = j + 1) begin
                if (adj_matrix[i * 5 + j] == 1 && colors[j] == temp_color) begin
                    // If adjacent node has the same color, increment temp_color
                    temp_color = temp_color + 1;
                end
            end
            
            // Assign the color to the current node
            colors[i] = temp_color;
        end
    end
endmodule