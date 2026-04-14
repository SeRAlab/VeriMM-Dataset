module graph_coloring (
    input [24:0] adjacency_matrix, // 5x5 adjacency matrix
    output reg can_color
);
    // Possible color assignments for 3 colors (0, 1, 2)
    reg [2:0] colors [4:0];
    integer i, j;

    always @(*) begin
        can_color = 1'b1; // Assume we can color
        // Iterate through the vertices
        for (i = 0; i < 5; i = i + 1) begin
            // Check adjacent vertices
            for (j = 0; j < 5; j = j + 1) begin
                if (adjacency_matrix[i*5 + j] && (colors[i] == colors[j])) begin
                    can_color = 1'b0; // Conflict found
                end
            end
        end
    end
endmodule