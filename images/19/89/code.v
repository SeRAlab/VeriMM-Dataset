module nearest_neighbor_interpolation (
    input [7:0] pixel00, // Top-left pixel
    input [7:0] pixel01, // Top-right pixel
    input [7:0] pixel10, // Bottom-left pixel
    input [7:0] pixel11, // Bottom-right pixel
    input [1:0] x,       // x coordinate for 4x4 grid (0 to 3)
    input [1:0] y,       // y coordinate for 4x4 grid (0 to 3)
    output reg [7:0] pixel_out // Output pixel value
);
    always @(*) begin
        case ({y, x})
            4'b00_00: pixel_out = pixel00; // (0,0)
            4'b00_01: pixel_out = pixel01; // (0,1)
            4'b01_00: pixel_out = pixel10; // (1,0)
            4'b01_01: pixel_out = pixel11; // (1,1)
            4'b00_10: pixel_out = pixel00; // (0,2)
            4'b00_11: pixel_out = pixel01; // (0,3)
            4'b01_10: pixel_out = pixel10; // (2,0)
            4'b01_11: pixel_out = pixel11; // (2,1)
            4'b10_00: pixel_out = pixel00; // (2,2)
            4'b10_01: pixel_out = pixel01; // (2,3)
            4'b11_00: pixel_out = pixel10; // (3,2)
            4'b11_01: pixel_out = pixel11; // (3,3)
            default: pixel_out = 8'b0;      // default case
        endcase
    end
endmodule