module nearest_neighbor_interpolation(
    input [7:0] original_pixel, // Original pixel value (8-bit)
    input [1:0] x_coord,        // X coordinate (2-bit)
    input [1:0] y_coord,        // Y coordinate (2-bit)
    output reg [7:0] interpolated_pixel // Interpolated pixel value (8-bit)
);

always @(*) begin
    case ({x_coord, y_coord})
        4'b0000: interpolated_pixel = original_pixel; // (0,0)
        4'b0001: interpolated_pixel = original_pixel; // (0,1)
        4'b0010: interpolated_pixel = original_pixel; // (1,0)
        4'b0011: interpolated_pixel = original_pixel; // (1,1)
        default: interpolated_pixel = 8'b00000000;    // Default case
    endcase
end

endmodule