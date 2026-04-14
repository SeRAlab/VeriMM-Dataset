module gaussian_blur (
    input [7:0] pixel_00, input [7:0] pixel_01, input [7:0] pixel_02,
    input [7:0] pixel_10, input [7:0] pixel_11, input [7:0] pixel_12,
    input [7:0] pixel_20, input [7:0] pixel_21, input [7:0] pixel_22,
    output [7:0] output_pixel
);
    wire [15:0] weighted_sum;
    
    assign weighted_sum = (pixel_00 * 1) + (pixel_01 * 2) + (pixel_02 * 1) +
                          (pixel_10 * 2) + (pixel_11 * 4) + (pixel_12 * 2) +
                          (pixel_20 * 1) + (pixel_21 * 2) + (pixel_22 * 1);
    
    assign output_pixel = weighted_sum / 16;
endmodule