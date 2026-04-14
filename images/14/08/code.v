module gaussian_blur (
    input [7:0] pixel_0, // Top-left
    input [7:0] pixel_1, // Top-center
    input [7:0] pixel_2, // Top-right
    input [7:0] pixel_3, // Middle-left
    input [7:0] pixel_4, // Middle-center
    input [7:0] pixel_5, // Middle-right
    input [7:0] pixel_6, // Bottom-left
    input [7:0] pixel_7, // Bottom-center
    input [7:0] pixel_8, // Bottom-right
    output reg [7:0] blurred_pixel
);
    always @* begin
        blurred_pixel = (pixel_0 + pixel_1*2 + pixel_2 + 
                         pixel_3*2 + pixel_4*4 + pixel_5*2 +
                         pixel_6 + pixel_7*2 + pixel_8) / 16;
    end
endmodule