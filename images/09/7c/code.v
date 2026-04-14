module kmeans_clustering(
    input [7:0] x1, 
    input [7:0] y1, 
    input [7:0] x2, 
    input [7:0] y2, 
    output reg closest_centroid
);
    wire [15:0] dist1, dist2;

    // Calculate Euclidean distance squared to centroid C0 (0, 0)
    assign dist1 = (x1 * x1 + y1 * y1);
    assign dist2 = ((x2 - 8'd1) * (x2 - 8'd1) + (y2 - 8'd1) * (y2 - 8'd1));

    always @(*) begin
        if (dist1 < dist2)
            closest_centroid = 1'b0; // Closest to C0
        else
            closest_centroid = 1'b1; // Closest to C1
    end
endmodule