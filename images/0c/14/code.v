module png_sub_filter (
    input [7:0] pixel_in,
    input [7:0] left_pixel, // pixel to the left
    output reg [7:0] pixel_out
);
    
    always @(*) begin
        pixel_out = pixel_in - left_pixel;
    end
    
endmodule