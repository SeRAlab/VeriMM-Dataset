module k_means_clustering (
    input [7:0] data_point,
    input [7:0] centroid0,
    input [7:0] centroid1,
    input [7:0] centroid2,
    output reg [2:0] nearest_cluster
);
    wire [7:0] dist0, dist1, dist2;
    
    assign dist0 = (data_point - centroid0) * (data_point - centroid0);
    assign dist1 = (data_point - centroid1) * (data_point - centroid1);
    assign dist2 = (data_point - centroid2) * (data_point - centroid2);
    
    always @(*) begin
        if (dist0 <= dist1 && dist0 <= dist2) begin
            nearest_cluster = 3'b000; // Cluster 0
        end else if (dist1 <= dist0 && dist1 <= dist2) begin
            nearest_cluster = 3'b001; // Cluster 1
        end else begin
            nearest_cluster = 3'b010; // Cluster 2
        end
    end
endmodule