module nearest_neighbor_interpolation(
    input [7:0] pixel_value, // Input pixel value (8 bits)
    input [3:0] x_coord,     // X coordinate (4 bits)
    input [3:0] y_coord,     // Y coordinate (4 bits)
    output reg [7:0] output_pixel // Output pixel value (8 bits)
);
    always @(*) begin
        // For nearest neighbor interpolation,
        // simply output the input pixel value if the coordinates are valid
        output_pixel = pixel_value;
    end
endmodule