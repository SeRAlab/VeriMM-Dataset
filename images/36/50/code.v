module canny_non_max_suppression (
    input [7:0] pixel_00, // Top-left
    input [7:0] pixel_01, // Top-center
    input [7:0] pixel_02, // Top-right
    input [7:0] pixel_10, // Middle-left
    input [7:0] pixel_11, // Middle-center
    input [7:0] pixel_12, // Middle-right
    input [7:0] pixel_20, // Bottom-left
    input [7:0] pixel_21, // Bottom-center
    input [7:0] pixel_22, // Bottom-right
    output reg [7:0] suppressed_intensity
);

    always @(*) begin
        // Assume we have calculated the gradient direction and are using the center pixel
        suppressed_intensity = pixel_11; // Start with the center pixel
        // Check for non-maximum suppression in horizontal direction
        if (pixel_01 >= pixel_11 || pixel_12 >= pixel_11) begin
            suppressed_intensity = 8'b0; // Suppress if not local maximum
        end
    end
endmodule