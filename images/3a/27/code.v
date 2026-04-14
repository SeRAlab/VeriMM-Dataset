module k_means_clustering (
    input [4:0] x,
    input [4:0] y,
    output reg [1:0] centroid_index
);
    // Define the centroids (x, y)
    reg [4:0] centroids [0:3][0:1]; // 4 centroids, each with x and y
    initial begin
        centroids[0][0] = 5'd5;   // Centroid 0 x-coordinate
        centroids[0][1] = 5'd2;   // Centroid 0 y-coordinate
        centroids[1][0] = 5'd1;   // Centroid 1 x-coordinate
        centroids[1][1] = 5'd4;   // Centroid 1 y-coordinate
        centroids[2][0] = 5'd3;   // Centroid 2 x-coordinate
        centroids[2][1] = 5'd1;   // Centroid 2 y-coordinate
        centroids[3][0] = 5'd4;   // Centroid 3 x-coordinate
        centroids[3][1] = 5'd5;   // Centroid 3 y-coordinate
    end

    integer i;
    reg [9:0] min_distance; // Maximum distance for 5-bit values
    reg [9:0] distance;

    always @(*) begin
        min_distance = 10'd1024; // Initialize with max distance
        centroid_index = 2'b00; // Default index

        for (i = 0; i < 4; i = i + 1) begin
            // Calculate squared distance
            distance = (x - centroids[i][0]) * (x - centroids[i][0]) +
                       (y - centroids[i][1]) * (y - centroids[i][1]);
            if (distance < min_distance) begin
                min_distance = distance;
                centroid_index = i[1:0]; // Keep 2 bits for index
            end
        end
    end
endmodule