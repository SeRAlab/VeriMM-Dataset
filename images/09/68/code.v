module nearest_neighbor_interpolation (
    input [7:0] pixel_left,
    input [7:0] pixel_center,
    input [7:0] pixel_right,
    output reg [7:0] output_pixel
);

always @(*) begin
    if (pixel_center >= pixel_left && pixel_center >= pixel_right) 
        output_pixel = pixel_center;
    else if (pixel_left >= pixel_center && pixel_left >= pixel_right) 
        output_pixel = pixel_left;
    else 
        output_pixel = pixel_right;
end

endmodule