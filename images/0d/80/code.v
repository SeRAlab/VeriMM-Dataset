module knn_classifier (
    input [7:0] point_x,     // x-coordinate of the input point
    input [7:0] point_y,     // y-coordinate of the input point
    input [7:0] point1_x,    // x-coordinate of the first reference point
    input [7:0] point1_y,    // y-coordinate of the first reference point
    input [7:0] point2_x,    // x-coordinate of the second reference point
    input [7:0] point2_y,    // y-coordinate of the second reference point
    output reg classification  // classification output: 0 or 1
);
    wire [15:0] dist1, dist2; // distances squared for comparison

    assign dist1 = (point_x - point1_x) * (point_x - point1_x) + (point_y - point1_y) * (point_y - point1_y);
    assign dist2 = (point_x - point2_x) * (point_x - point2_x) + (point_y - point2_y) * (point_y - point2_y);

    always @(*) begin
        if (dist1 < dist2)
            classification = 0; // classify as point1
        else
            classification = 1; // classify as point2
    end
endmodule