module k_means(
    input clk,
    input reset,
    input [44:0] data_points, // 5 data points, each 9 bits (3 bits for x, y, z)
    output reg [44:0] centroids, // 5 centroids
    output reg valid
);
    parameter NUM_CLUSTERS = 5;
    reg [2:0] iter;
    reg [44:0] temp_centroids;
    
    // Initial centroids
    initial begin
        centroids = 45'b0; // Initialize centroids to zero
        valid = 0;
        iter = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            centroids <= 45'b0;
            valid <= 0;
            iter <= 0;
        end else if (iter < 8) begin
            // K-means algorithm for 5 data points
            // Simple averaging for centroids
            temp_centroids[2:0] = (data_points[8:6] + data_points[17:15] + data_points[26:24] + data_points[35:33] + data_points[44:42]) / NUM_CLUSTERS; // x
            temp_centroids[11:9] = (data_points[5:3] + data_points[14:12] + data_points[23:21] + data_points[32:30] + data_points[41:39]) / NUM_CLUSTERS; // y
            temp_centroids[20:18] = (data_points[2:0] + data_points[11:9] + data_points[20:18] + data_points[29:27] + data_points[38:36]) / NUM_CLUSTERS; // z
            
            centroids <= temp_centroids; // update centroids
            valid <= 1; // signal that valid centroids are obtained
            iter <= iter + 1; // next iteration
        end
    end
endmodule