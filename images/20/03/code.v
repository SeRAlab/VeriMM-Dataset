module gaussian_blur (
    input [7:0] pixel_in_00, // Top-left pixel
    input [7:0] pixel_in_01, // Top-middle pixel
    input [7:0] pixel_in_02, // Top-right pixel
    input [7:0] pixel_in_10, // Middle-left pixel
    input [7:0] pixel_in_11, // Center pixel
    input [7:0] pixel_in_12, // Middle-right pixel
    input [7:0] pixel_in_20, // Bottom-left pixel
    input [7:0] pixel_in_21, // Bottom-middle pixel
    input [7:0] pixel_in_22, // Bottom-right pixel
    output reg [7:0] pixel_out // Blurred pixel output
);

always @(*) begin
    // Gaussian blur calculation
    pixel_out = (pixel_in_00 + pixel_in_01 * 2 + pixel_in_02 + 
                 pixel_in_10 * 2 + pixel_in_11 * 4 + pixel_in_12 * 2 + 
                 pixel_in_20 + pixel_in_21 * 2 + pixel_in_22) / 16;
end

endmodule