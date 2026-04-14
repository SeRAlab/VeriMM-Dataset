module nearest_neighbor_interpolation(
    input [7:0] pixel00, // Pixel (0,0)
    input [7:0] pixel01, // Pixel (0,1)
    input [7:0] pixel10, // Pixel (1,0)
    input [7:0] pixel11, // Pixel (1,1)
    input [1:0] x,       // X coordinate (0 or 1)
    input [1:0] y,       // Y coordinate (0 or 1)
    output reg [7:0] interpolated_pixel // Output pixel value
);
    always @(*) begin
        case ({y, x}) // Combine y and x for easier case selection
            2'b00: interpolated_pixel = pixel00; // (0,0)
            2'b01: interpolated_pixel = pixel01; // (0,1)
            2'b10: interpolated_pixel = pixel10; // (1,0)
            2'b11: interpolated_pixel = pixel11; // (1,1)
            default: interpolated_pixel = 8'b0; // Default case
        endcase
    end
endmodule