module kmeans_clustering (
    input [7:0] data_point, // 8-bit input data point
    input [7:0] centroid1,   // 8-bit first centroid
    input [7:0] centroid2,   // 8-bit second centroid
    output reg [1:0] cluster  // output cluster assignment: 00 for centroid1, 01 for centroid2
);
    always @(*) begin
        // Calculate the distance to centroid1 and centroid2
        if (data_point - centroid1 < data_point - centroid2) begin
            cluster = 2'b00; // Assign to cluster 1
        end else begin
            cluster = 2'b01; // Assign to cluster 2
        end
    end
endmodule