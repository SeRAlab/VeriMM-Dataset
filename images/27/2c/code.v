module gaussian_blur (
    input [7:0] pixel_00, pixel_01, pixel_02,
    input [7:0] pixel_10, pixel_11, pixel_12,
    input [7:0] pixel_20, pixel_21, pixel_22,
    output reg [7:0] blurred_pixel
);
    
    always @(*) begin
        blurred_pixel = (pixel_00 + pixel_01*2 + pixel_02 +
                         pixel_10*2 + pixel_11*4 + pixel_12*2 +
                         pixel_20 + pixel_21*2 + pixel_22) / 16;
    end
endmodule