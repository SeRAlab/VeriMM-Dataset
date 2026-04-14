module graph_coloring (
    input [15:0] adjacency_matrix, // 4x4 adjacency matrix for simplicity
    output reg [7:0] colors // 4 nodes, each node colored with 2 bits
);
    integer i, j;
    reg [1:0] color_used [3:0]; // colors used for nodes
    reg [1:0] available_colors [3:0]; // available colors for each node

    always @(*) begin
        // Initialize available colors
        for (i = 0; i < 4; i = i + 1) begin
            available_colors[i] = 2'b11; // All colors available
        end

        // Check which colors are used by adjacent nodes
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                if (adjacency_matrix[i*4+j] && colors[j*2 +: 2] != 2'b00) begin
                    available_colors[i][colors[j*2 +: 2]] = 1'b0; // mark color as unavailable
                end
            end
        end

        // Assign colors to nodes
        for (i = 0; i < 4; i = i + 1) begin
            colors[i*2 +: 2] = 2'b00; // Default color
            if (available_colors[i][0]) colors[i*2 +: 2] = 2'b00;
            else if (available_colors[i][1]) colors[i*2 +: 2] = 2'b01;
            else if (available_colors[i][2]) colors[i*2 +: 2] = 2'b10;
            else if (available_colors[i][3]) colors[i*2 +: 2] = 2'b11;
        end
    end
endmodule