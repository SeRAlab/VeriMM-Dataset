module kmeans_clustering (
    input [7:0] point_x,
    input [7:0] point_y,
    input [7:0] centroid1_x,
    input [7:0] centroid1_y,
    input [7:0] centroid2_x,
    input [7:0] centroid2_y,
    output reg cluster
);
    wire [15:0] distance1, distance2;

    assign distance1 = (point_x - centroid1_x) * (point_x - centroid1_x) + (point_y - centroid1_y) * (point_y - centroid1_y);
    assign distance2 = (point_x - centroid2_x) * (point_x - centroid2_x) + (point_y - centroid2_y) * (point_y - centroid2_y);

    always @(*) begin
        if (distance1 < distance2)
            cluster = 0; // Assign to cluster 1
        else
            cluster = 1; // Assign to cluster 2
    end
endmodule