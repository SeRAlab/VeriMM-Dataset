module knn (
    input [3:0] point1_x, point1_y,
    input [3:0] point2_x, point2_y,
    input [3:0] point3_x, point3_y,
    input [3:0] point4_x, point4_y,
    input [3:0] target_x, target_y,
    output reg [1:0] nearest_index
);

    reg [7:0] dist1, dist2, dist3, dist4;

    always @(*) begin
        // Calculate squared distances to avoid using sqrt
        dist1 = (point1_x - target_x) ** 2 + (point1_y - target_y) ** 2;
        dist2 = (point2_x - target_x) ** 2 + (point2_y - target_y) ** 2;
        dist3 = (point3_x - target_x) ** 2 + (point3_y - target_y) ** 2;
        dist4 = (point4_x - target_x) ** 2 + (point4_y - target_y) ** 2;

        // Determine the nearest neighbor
        if (dist1 <= dist2 && dist1 <= dist3 && dist1 <= dist4)
            nearest_index = 2'b00;
        else if (dist2 <= dist1 && dist2 <= dist3 && dist2 <= dist4)
            nearest_index = 2'b01;
        else if (dist3 <= dist1 && dist3 <= dist2 && dist3 <= dist4)
            nearest_index = 2'b10;
        else
            nearest_index = 2'b11; // This implies dist4 is the smallest
    end
endmodule