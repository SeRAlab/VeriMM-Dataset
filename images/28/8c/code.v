module kmeans_clustering (
    input [7:0] x1, y1, // Coordinates of point 1
    input [7:0] x2, y2, // Coordinates of point 2
    input [7:0] cx1, cy1, // Centroid 1 coordinates
    input [7:0] cx2, cy2, // Centroid 2 coordinates
    output reg [1:0] cluster1, // Cluster assignment for point 1
    output reg [1:0] cluster2 // Cluster assignment for point 2
);

    wire [15:0] dist1_to_c1, dist1_to_c2, dist2_to_c1, dist2_to_c2;

    // Calculate squared distances to avoid sqrt
    assign dist1_to_c1 = (x1 - cx1) * (x1 - cx1) + (y1 - cy1) * (y1 - cy1);
    assign dist1_to_c2 = (x1 - cx2) * (x1 - cx2) + (y1 - cy2) * (y1 - cy2);
    assign dist2_to_c1 = (x2 - cx1) * (x2 - cx1) + (y2 - cy1) * (y2 - cy1);
    assign dist2_to_c2 = (x2 - cx2) * (x2 - cx2) + (y2 - cy2) * (y2 - cy2);

    // Assign clusters based on minimum distance
    always @* begin
        cluster1 = (dist1_to_c1 < dist1_to_c2) ? 0 : 1;
        cluster2 = (dist2_to_c1 < dist2_to_c2) ? 0 : 1;
    end
endmodule