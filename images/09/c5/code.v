module gaussian_blur (
    input [8:0] pixel_00, // top left
    input [8:0] pixel_01, // top center
    input [8:0] pixel_02, // top right
    input [8:0] pixel_10, // middle left
    input [8:0] pixel_11, // middle center
    input [8:0] pixel_12, // middle right
    input [8:0] pixel_20, // bottom left
    input [8:0] pixel_21, // bottom center
    input [8:0] pixel_22, // bottom right
    output reg [8:0] blurred_pixel
);
    always @(*) begin
        // Calculate the weighted sum according to the Gaussian kernel
        blurred_pixel = ((1 * pixel_00) + (2 * pixel_01) + (1 * pixel_02) +
                         (2 * pixel_10) + (4 * pixel_11) + (2 * pixel_12) +
                         (1 * pixel_20) + (2 * pixel_21) + (1 * pixel_22)) / 16;
    end
endmodule