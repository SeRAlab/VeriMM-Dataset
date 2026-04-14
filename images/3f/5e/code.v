module Floyd_Warshall(
    input [15:0] weights, // 4x4 matrix
    output reg [15:0] shortest_paths // 4x4 matrix
);
    integer i, j, k;
    reg [15:0] temp [0:3][0:3];

    always @(*) begin
        // Initialize shortest_paths with the weights
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                if (i == j)
                    temp[i][j] = 0; // Distance to self is zero
                else
                    temp[i][j] = weights[i*4 + j]; // Assign weight
            end
        end
        
        // Floyd-Warshall algorithm
        for (k = 0; k < 4; k = k + 1) begin
            for (i = 0; i < 4; i = i + 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    if (temp[i][k] + temp[k][j] < temp[i][j])
                        temp[i][j] = temp[i][k] + temp[k][j];
                end
            end
        end
        
        // Assign result to shortest_paths
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                shortest_paths[i*4+j] = temp[i][j];
            end
        end
    end
endmodule