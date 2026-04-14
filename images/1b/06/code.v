module canny_edge_detector (
    input [7:0] pixel_00, input [7:0] pixel_01, input [7:0] pixel_02,
    input [7:0] pixel_10, input [7:0] pixel_11, input [7:0] pixel_12,
    input [7:0] pixel_20, input [7:0] pixel_21, input [7:0] pixel_22,
    input [7:0] threshold,
    output reg [0:0] edge_out
);
    wire [15:0] gx, gy;
    wire [15:0] gradient_magnitude;

    // Sobel operators for x and y direction
    assign gx = (pixel_00 * -1 + pixel_02 * 1) +
                (pixel_10 * -2 + pixel_12 * 2) +
                (pixel_20 * -1 + pixel_22 * 1);
    
    assign gy = (pixel_00 * -1 + pixel_10 * -2 + pixel_20 * -1) +
                (pixel_02 * 1 + pixel_12 * 2 + pixel_22 * 1);

    // Calculate gradient magnitude
    assign gradient_magnitude = (gx * gx) + (gy * gy);

    // Determine if the edge is detected based on the threshold
    always @(*) begin
        if (gradient_magnitude[15:8] > threshold) // Use the high byte for threshold comparison
            edge_out = 1'b1;
        else
            edge_out = 1'b0;
    end
endmodule