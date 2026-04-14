module nearest_neighbor_interpolation (
    input [7:0] pixel1,
    input [7:0] pixel2,
    input [1:0] scale, // scale factor (0 = 1x, 1 = 2x, 2 = 3x, 3 = 4x)
    output reg [7:0] interpolated_pixel
);
    
    always @(*) begin
        case (scale)
            2'b00: interpolated_pixel = pixel1;                // 1x
            2'b01: interpolated_pixel = (pixel1 + pixel2) >> 1; // 2x (average of two)
            2'b10: interpolated_pixel = pixel1;                // 3x (nearest neighbor)
            2'b11: interpolated_pixel = pixel2;                // 4x (nearest neighbor)
            default: interpolated_pixel = 8'b00000000;         // default case
        endcase
    end
endmodule