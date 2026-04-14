module floyd_warshall (
    input [0:8*3*3-1] weight_matrix, // 3x3 matrix packed into a single input
    output reg [0:8*3*3-1] shortest_paths  // 3x3 matrix packed into a single output
);
    integer i, j, k;
    reg [7:0] dist [0:2][0:2]; // Distance matrix

    always @(*) begin
        // Initialize distance matrix from weight_matrix
        for (i = 0; i < 3; i = i + 1) begin
            for (j = 0; j < 3; j = j + 1) begin
                dist[i][j] = weight_matrix[(i*3 + j) * 8 +: 8];
            end
        end
        
        // Floyd-Warshall algorithm
        for (k = 0; k < 3; k = k + 1) begin
            for (i = 0; i < 3; i = i + 1) begin
                for (j = 0; j < 3; j = j + 1) begin
                    if (dist[i][j] > dist[i][k] + dist[k][j]) begin
                        dist[i][j] = dist[i][k] + dist[k][j];
                    end
                end
            end
        end
        
        // Output the shortest paths matrix
        for (i = 0; i < 3; i = i + 1) begin
            for (j = 0; j < 3; j = j + 1) begin
                shortest_paths[(i*3 + j) * 8 +: 8] = dist[i][j];
            end
        end
    end
endmodule