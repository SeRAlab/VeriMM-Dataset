module kmeans (
    input [7:0] point1_x, 
    input [7:0] point1_y,
    input [7:0] point2_x, 
    input [7:0] point2_y,
    output reg [7:0] centroid_x, 
    output reg [7:0] centroid_y
);
    always @(*) begin
        centroid_x = (point1_x + point2_x) >> 1; // Average X
        centroid_y = (point1_y + point2_y) >> 1; // Average Y
    end
endmodule