module FloydWarshall (
    input [15:0] weights, // 4x4 weight matrix (16 bits)
    output reg [15:0] distances // 4x4 shortest path distance matrix
);
    integer i, j, k;
    reg [15:0] dist [0:3][0:3];

    always @(*) begin
        // Initialize the distance matrix
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                if (i == j) begin
                    dist[i][j] = 0;
                end else if (weights[(i*4+j)] == 16'hFFFF) begin // Treat 0xFFFF as infinity
                    dist[i][j] = 16'hFFFF;
                end else begin
                    dist[i][j] = weights[(i*4+j)];
                end
            end
        end

        // Floyd-Warshall algorithm
        for (k = 0; k < 4; k = k + 1) begin
            for (i = 0; i < 4; i = i + 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    if (dist[i][k] + dist[k][j] < dist[i][j]) begin
                        dist[i][j] = dist[i][k] + dist[k][j];
                    end
                end
            end
        end

        // Assign final distances
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                distances[(i*4+j)] = dist[i][j];
            end
        end
    end
endmodule