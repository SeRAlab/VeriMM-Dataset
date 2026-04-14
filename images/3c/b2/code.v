module nearest_neighbor_interpolation (
    input [7:0] pixel_a, // First pixel value
    input [7:0] pixel_b, // Second pixel value
    input select,        // Select signal to choose between pixel_a and pixel_b
    output reg [7:0] interpolated_pixel // Output interpolated pixel value
);

always @(*) begin
    if (select) begin
        interpolated_pixel = pixel_b; // Select pixel_b
    end else begin
        interpolated_pixel = pixel_a; // Select pixel_a
    end
end

endmodule