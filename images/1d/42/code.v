module graph_coloring (
    input [0:15] adj_matrix, // 4x4 adjacency matrix for a graph with 4 vertices
    output reg can_color
);
    reg [3:0] color; // 0: uncolored, 1: color1, 2: color2
    integer i, j;

    always @(*) begin
        can_color = 1; // Assume it can be colored
        color = 4'b0000; // No vertices colored

        // Perform a simple check for bipartiteness
        for (i = 0; i < 4; i = i + 1) begin
            if (color[i] == 0) begin
                color[i] = 1; // Start coloring with color 1
                for (j = 0; j < 4; j = j + 1) begin
                    if (adj_matrix[i * 4 + j] == 1) begin // Check adjacency
                        if (color[j] == 0) begin
                            color[j] = 2; // Color with the other color
                        end else if (color[j] == color[i]) begin
                            can_color = 0; // Conflict in coloring
                        end
                    end
                end
            end
        end
    end
endmodule