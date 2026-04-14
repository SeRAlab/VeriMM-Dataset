module nearest_neighbor_interpolation (
    input [7:0] pixel_a,
    input [7:0] pixel_b,
    input [1:0] factor, // Interpolation factor: 00 = 1, 01 = 2
    output reg [7:0] interpolated_pixel
);

always @(*) begin
    case (factor)
        2'b00: interpolated_pixel = pixel_a; // No interpolation
        2'b01: interpolated_pixel = (pixel_a + pixel_b) >> 1; // Average of two pixels for interpolation
        default: interpolated_pixel = 8'b00000000; // Default case
    endcase
end

endmodule