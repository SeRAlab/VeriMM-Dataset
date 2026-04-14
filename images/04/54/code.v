module canny_edge_detection (
    input [7:0] pixel_00, pixel_01, pixel_02,
    input [7:0] pixel_10, pixel_11, pixel_12,
    input [7:0] pixel_20, pixel_21, pixel_22,
    input [7:0] threshold,
    output reg edge_detected
);

    wire signed [8:0] gx, gy;
    wire signed [8:0] gradient_magnitude;

    // Sobel operator for edge detection
    assign gx = (pixel_00 + 2 * pixel_01 + pixel_02) - (pixel_20 + 2 * pixel_21 + pixel_22);
    assign gy = (pixel_00 + 2 * pixel_10 + pixel_20) - (pixel_02 + 2 * pixel_12 + pixel_22);
    
    assign gradient_magnitude = (gx * gx + gy * gy) >> 1; // Calculate gradient magnitude

    always @(*) begin
        if (gradient_magnitude > threshold)
            edge_detected = 1;
        else
            edge_detected = 0;
    end
endmodule