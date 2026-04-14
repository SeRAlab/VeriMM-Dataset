module nearest_neighbor_interpolation(
    input [7:0] pixel_00, // Top-left pixel
    input [7:0] pixel_01, // Top-right pixel
    input [7:0] pixel_10, // Bottom-left pixel
    input [7:0] pixel_11, // Bottom-right pixel
    input [1:0] x_interp,  // X interpolation coordinate (0 or 1)
    input [1:0] y_interp,  // Y interpolation coordinate (0 or 1)
    output reg [7:0] pixel_out // Interpolated pixel output
);

always @(*) begin
    case (x_interp)
        2'b00: begin
            case (y_interp)
                2'b00: pixel_out = pixel_00; // Top-left
                2'b01: pixel_out = pixel_10; // Bottom-left
                default: pixel_out = 8'b0;    // Default case
            endcase
        end
        2'b01: begin
            case (y_interp)
                2'b00: pixel_out = pixel_01; // Top-right
                2'b01: pixel_out = pixel_11; // Bottom-right
                default: pixel_out = 8'b0;    // Default case
            endcase
        end
        default: pixel_out = 8'b0; // Default case
    endcase
end

endmodule