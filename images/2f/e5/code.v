module FloydWarshall (
    input [15:0] weight_matrix, // 4x4 matrix flattened
    output reg [15:0] shortest_paths // 4x4 matrix flattened
);
    integer i, j, k;
    reg [3:0] dist [0:3][0:3]; // 4x4 distance matrix

    always @(*) begin
        // Initialize distance matrix
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                if (i == j)
                    dist[i][j] = 0;
                else if (weight_matrix[i * 4 + j] == 0)
                    dist[i][j] = 16'hFFFF; // Infinity
                else
                    dist[i][j] = weight_matrix[i * 4 + j];
            end
        end

        // Floyd-Warshall algorithm
        for (k = 0; k < 4; k = k + 1) begin
            for (i = 0; i < 4; i = i + 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    if (dist[i][j] > (dist[i][k] + dist[k][j])) begin
                        dist[i][j] = dist[i][k] + dist[k][j];
                    end
                end
            end
        end

        // Flatten the distance matrix to output
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                shortest_paths[i * 4 + j] = dist[i][j];
            end
        end
    end
endmodule