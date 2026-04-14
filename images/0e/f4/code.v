module k_means (
    input [7:0] x,
    input [7:0] y,
    input [7:0] cx,
    input [7:0] cy,
    output reg [1:0] index
);
    wire [15:0] dist1, dist2; // distance squared for two centroids
    reg [15:0] min_dist;

    // Calculate squared distances to avoid floating point operations
    assign dist1 = (x - cx) * (x - cx) + (y - cy) * (y - cy);
    // Assume we have a second centroid (cx2, cy2) for demonstration; replacing with constants for now
    assign dist2 = (x - 50) * (x - 50) + (y - 50) * (y - 50); // second centroid at (50,50)

    always @(*) begin
        if (dist1 < dist2) begin
            index = 0; // closest to first centroid
        end else begin
            index = 1; // closest to second centroid
        end
    end
endmodule