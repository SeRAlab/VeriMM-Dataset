module knn_classifier (
    input [1:0] point_a,
    input [1:0] point_b,
    output reg class
);

    wire [3:0] dist_to_class0;
    wire [3:0] dist_to_class1;

    assign dist_to_class0 = (point_a[1:0] - 2'b00) * (point_a[1:0] - 2'b00) + (point_b[1:0] - 2'b00) * (point_b[1:0] - 2'b00);
    assign dist_to_class1 = (point_a[1:0] - 2'b01) * (point_a[1:0] - 2'b01) + (point_b[1:0] - 2'b01) * (point_b[1:0] - 2'b01);

    always @* begin
        if (dist_to_class0 < dist_to_class1)
            class = 1'b0;
        else
            class = 1'b1;
    end
endmodule