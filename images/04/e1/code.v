module convolution_3x3 (
    input [7:0] pixel_00, input [7:0] pixel_01, input [7:0] pixel_02,
    input [7:0] pixel_10, input [7:0] pixel_11, input [7:0] pixel_12,
    input [7:0] pixel_20, input [7:0] pixel_21, input [7:0] pixel_22,
    input signed [7:0] kernel_00, input signed [7:0] kernel_01, input signed [7:0] kernel_02,
    input signed [7:0] kernel_10, input signed [7:0] kernel_11, input signed [7:0] kernel_12,
    input signed [7:0] kernel_20, input signed [7:0] kernel_21, input signed [7:0] kernel_22,
    output reg signed [15:0] output_pixel
);
    always @(*) begin
        output_pixel = (pixel_00 * kernel_00) + (pixel_01 * kernel_01) + (pixel_02 * kernel_02) +
                       (pixel_10 * kernel_10) + (pixel_11 * kernel_11) + (pixel_12 * kernel_12) +
                       (pixel_20 * kernel_20) + (pixel_21 * kernel_21) + (pixel_22 * kernel_22);
    end
endmodule