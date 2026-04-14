module image_convolution (
    input [7:0] pixel00, pixel01, pixel02,
    input [7:0] pixel10, pixel11, pixel12,
    input [7:0] pixel20, pixel21, pixel22,
    input [8:0] kernel, // 9-bit kernel (3x3)
    output reg [7:0] output_pixel
);
    always @(*) begin
        // Applying convolution
        output_pixel = (pixel00 * kernel[8]) + (pixel01 * kernel[7]) + (pixel02 * kernel[6]) +
                       (pixel10 * kernel[5]) + (pixel11 * kernel[4]) + (pixel12 * kernel[3]) +
                       (pixel20 * kernel[2]) + (pixel21 * kernel[1]) + (pixel22 * kernel[0]);
        
        // Clamping between 0 and 255
        if (output_pixel > 255) output_pixel = 255;
        else if (output_pixel < 0) output_pixel = 0;
    end
endmodule