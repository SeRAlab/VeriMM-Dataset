module floyd_warshall (
    input [15:0] adj_matrix, // 4x4 adjacency matrix (flattened)
    output reg [15:0] shortest_path // 4x4 shortest path matrix (flattened)
);

integer i, j, k;
reg [3:0] dist [0:3][0:3]; // distance matrix

always @(*) begin
    // Initialize distance matrix
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            if (i == j) 
                dist[i][j] = 0; // Distance to self is 0
            else if (adj_matrix[i*4 + j] != 0)
                dist[i][j] = adj_matrix[i*4 + j]; // Existing edge weight
            else
                dist[i][j] = 16'hFFFF; // Infinite distance
        end
    end

    // Floyd-Warshall algorithm
    for (k = 0; k < 4; k = k + 1) begin
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                if (dist[i][k] + dist[k][j] < dist[i][j]) 
                    dist[i][j] = dist[i][k] + dist[k][j];
            end
        end
    end

    // Output the shortest path matrix
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            shortest_path[i*4 + j] = dist[i][j];
        end
    end
end

endmodule