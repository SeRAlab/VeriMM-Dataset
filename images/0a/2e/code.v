module PNG_Sub_Filter (
    input [7:0] pixel_in,          // Current pixel value
    input [7:0] left_pixel_in,     // Left pixel value (0 for first pixel)
    output reg [7:0] pixel_out      // Output filtered pixel value
);

always @(*) begin
    if (left_pixel_in == 8'b0) begin
        pixel_out = pixel_in; // No left pixel, output current pixel value
    end else begin
        pixel_out = pixel_in - left_pixel_in; // Subtract left pixel from current pixel
    end
end

endmodule