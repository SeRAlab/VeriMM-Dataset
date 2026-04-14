module floyd_warshall (
    input clk,
    input reset,
    input [15:0] dist_0,
    input [15:0] dist_1,
    input [15:0] dist_2,
    input [15:0] dist_3,
    output reg [15:0] path_0,
    output reg [15:0] path_1,
    output reg [15:0] path_2,
    output reg [15:0] path_3
);
    reg [15:0] dist [0:3][0:3];
    integer k, i, j;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize distances
            dist[0][0] <= dist_0; 
            dist[1][1] <= dist_1; 
            dist[2][2] <= dist_2; 
            dist[3][3] <= dist_3; 
            for (i = 0; i < 4; i = i + 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    if (i != j) dist[i][j] <= 16'hFFFF; // Set infinity
                end
            end
        end else begin
            // Floyd-Warshall algorithm
            for (k = 0; k < 4; k = k + 1) begin
                for (i = 0; i < 4; i = i + 1) begin
                    for (j = 0; j < 4; j = j + 1) begin
                        if (dist[i][j] > dist[i][k] + dist[k][j]) begin
                            dist[i][j] <= dist[i][k] + dist[k][j];
                        end
                    end
                end
            end
            
            path_0 <= dist[0][0];
            path_1 <= dist[1][1];
            path_2 <= dist[2][2];
            path_3 <= dist[3][3];
        end
    end
endmodule