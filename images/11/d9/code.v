module kmeans_clustering (
    input [7:0] point_x,
    input [7:0] point_y,
    input [7:0] centroid1_x,
    input [7:0] centroid1_y,
    input [7:0] centroid2_x,
    input [7:0] centroid2_y,
    output reg [1:0] cluster_id
);
    reg [15:0] dist1;
    reg [15:0] dist2;

    always @(*) begin
        dist1 = (point_x - centroid1_x) * (point_x - centroid1_x) + (point_y - centroid1_y) * (point_y - centroid1_y);
        dist2 = (point_x - centroid2_x) * (point_x - centroid2_x) + (point_y - centroid2_y) * (point_y - centroid2_y);
        
        if (dist1 < dist2)
            cluster_id = 2'b00;  // Assigned to centroid 1
        else
            cluster_id = 2'b01;  // Assigned to centroid 2
    end
endmodule