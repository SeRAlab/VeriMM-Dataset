module nearest_neighbor_interpolation (
    input wire [7:0] pixel_in, // Input pixel value
    input wire [3:0] x_in,     // X coordinate in smaller image
    input wire [3:0] y_in,     // Y coordinate in smaller image
    output reg [7:0] pixel_out  // Output pixel value for larger image
);

always @(*) begin
    // Mapping smaller coordinates to larger coordinates
    // Nearest neighbor scaling by a factor of 2
    pixel_out = (x_in[3:1] * 4 + y_in[3:1] * 8) ? pixel_in : 8'b0;
end

endmodule