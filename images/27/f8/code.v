module kmeans (
    input clk,
    input reset,
    input [7:0] data_point_x0,
    input [7:0] data_point_y0,
    input [7:0] data_point_x1,
    input [7:0] data_point_y1,
    input [7:0] centroid_x0,
    input [7:0] centroid_y0,
    input [7:0] centroid_x1,
    input [7:0] centroid_y1,
    output reg [1:0] cluster_label0,
    output reg [1:0] cluster_label1
);
    
    reg [15:0] dist0_0, dist0_1, dist1_0, dist1_1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cluster_label0 <= 2'b00;
            cluster_label1 <= 2'b00;
        end else begin
            // Calculate squared distances from point 0 to centroids
            dist0_0 = (data_point_x0 - centroid_x0) ** 2 + (data_point_y0 - centroid_y0) ** 2;
            dist0_1 = (data_point_x0 - centroid_x1) ** 2 + (data_point_y0 - centroid_y1) ** 2;

            // Calculate squared distances from point 1 to centroids
            dist1_0 = (data_point_x1 - centroid_x0) ** 2 + (data_point_y1 - centroid_y0) ** 2;
            dist1_1 = (data_point_x1 - centroid_x1) ** 2 + (data_point_y1 - centroid_y1) ** 2;

            // Assign cluster labels based on the nearest centroid
            if (dist0_0 < dist0_1)
                cluster_label0 <= 2'b00; // Point 0 assigned to cluster 0
            else
                cluster_label0 <= 2'b01; // Point 0 assigned to cluster 1

            if (dist1_0 < dist1_1)
                cluster_label1 <= 2'b00; // Point 1 assigned to cluster 0
            else
                cluster_label1 <= 2'b01; // Point 1 assigned to cluster 1
        end
    end
endmodule