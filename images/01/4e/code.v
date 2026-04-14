module non_maximum_supression (
    input [7:0] pixel_00, input [7:0] pixel_01, input [7:0] pixel_02,
    input [7:0] pixel_10, input [7:0] pixel_11, input [7:0] pixel_12,
    input [7:0] pixel_20, input [7:0] pixel_21, input [7:0] pixel_22,
    input [3:0] direction, // 0: horizontal, 1: vertical, 2: diagonal /
    output reg [7:0] output_pixel
);

always @(*) begin
    case (direction)
        0: begin // Horizontal
            if (pixel_11 >= pixel_10 && pixel_11 >= pixel_12)
                output_pixel = pixel_11;
            else
                output_pixel = 8'b0;
        end
        1: begin // Vertical
            if (pixel_11 >= pixel_01 && pixel_11 >= pixel_21)
                output_pixel = pixel_11;
            else
                output_pixel = 8'b0;
        end
        2: begin // Diagonal
            if (pixel_11 >= pixel_00 && pixel_11 >= pixel_22)
                output_pixel = pixel_11;
            else
                output_pixel = 8'b0;
        end
        default: output_pixel = 8'b0;
    endcase
end

endmodule