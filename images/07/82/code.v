module floyd_warshall (
    input [15:0] adj_matrix, // 4x4 adjacency matrix (16 bits for 4 nodes)
    output reg [15:0] shortest_paths // 4x4 shortest paths matrix
);
    integer i, j, k;
    reg [3:0] dist [0:4][0:4];

    initial begin
        // Initialize the distance matrix
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                if (i == j)
                    dist[i][j] = 0;
                else if (adj_matrix[i*4+j] == 1) // 1 indicates edge existence
                    dist[i][j] = 1; // Assume weight of edge is 1
                else
                    dist[i][j] = 4'b1111; // Infinity
            end
        end
        
        // Floyd-Warshall algorithm
        for (k = 0; k < 4; k = k + 1) begin
            for (i = 0; i < 4; i = i + 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    if (dist[i][j] > dist[i][k] + dist[k][j]) begin
                        dist[i][j] = dist[i][k] + dist[k][j];
                    end
                end
            end
        end

        // Assign the shortest paths matrix to output
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                shortest_paths[i*4+j] = dist[i][j];
            end
        end
    end
endmodule