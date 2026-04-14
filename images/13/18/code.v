module nearest_neighbor_interpolation(
    input [7:0] pixel_in,
    input [7:0] x_low,
    input [7:0] y_low,
    output reg [7:0] pixel_out
);
    
    always @(*) begin
        // For nearest neighbor interpolation, we simply replicate the pixel
        // at the low-resolution coordinates for the corresponding high-resolution coordinates.
        // If the coordinates are even, it stays the same, if odd, we take the nearest.
        // Assuming upscale factor of 2, we will check low coordinates.
        
        // The condition to find the nearest pixel by using x_low and y_low
        if ((x_low % 2 == 0) && (y_low % 2 == 0)) begin
            pixel_out = pixel_in; // pixel stays the same
        end else if ((x_low % 2 == 1) && (y_low % 2 == 0)) begin
            pixel_out = pixel_in; // use the same pixel for both
        end else if ((x_low % 2 == 0) && (y_low % 2 == 1)) begin
            pixel_out = pixel_in; // use the same pixel for both
        end else begin
            pixel_out = pixel_in; // still same pixel for odd-odd case
        end
    end
endmodule