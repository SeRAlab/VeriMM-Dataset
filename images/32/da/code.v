module nearest_neighbor_interpolation(
    input [1:0] x_in,
    input [1:0] y_in,
    input [7:0] pixel_00, // Pixel at (0,0)
    input [7:0] pixel_01, // Pixel at (0,1)
    input [7:0] pixel_10, // Pixel at (1,0)
    input [7:0] pixel_11, // Pixel at (1,1)
    output reg [7:0] pixel_out
);
    always @(*) begin
        case ({x_in, y_in})
            2'b00: pixel_out = pixel_00; // Output pixel (0,0)
            2'b01: pixel_out = pixel_01; // Output pixel (0,1)
            2'b10: pixel_out = pixel_10; // Output pixel (1,0)
            2'b11: pixel_out = pixel_11; // Output pixel (1,1)
            default: pixel_out = 8'b00000000; // Default case
        endcase
    end
endmodule