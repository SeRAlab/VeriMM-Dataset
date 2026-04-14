module floyd_warshall(
    input [15:0] weights,  // 4x4 matrix flattened (16 bits for 4 weights)
    output reg [15:0] dist // 4x4 matrix of shortest paths flattened
);
    integer i, j, k;
    reg [15:0] temp_dist [0:3][0:3]; // 4x4 distance array

    always @* begin
        // Initialize the distance matrix with weights
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                if (i == j) 
                    temp_dist[i][j] = 0; // Distance to self is 0
                else 
                    temp_dist[i][j] = (weights[(i*4 + j)*4 +: 4] == 4'b1111) ? 999 : weights[(i*4 + j)*4 +: 4]; // 'inf' check
            end
        end

        // Floyd-Warshall algorithm
        for (k = 0; k < 4; k = k + 1) begin
            for (i = 0; i < 4; i = i + 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    if (temp_dist[i][j] > temp_dist[i][k] + temp_dist[k][j]) begin
                        temp_dist[i][j] = temp_dist[i][k] + temp_dist[k][j];
                    end
                end
            end
        end

        // Flatten the distance array for output
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                dist[(i*4 + j)*4 +: 4] = temp_dist[i][j];
            end
        end
    end
endmodule