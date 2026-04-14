module png_filter(
    input [7:0] current_pixel,
    input [7:0] previous_pixel,
    output [7:0] filtered_pixel
);
    assign filtered_pixel = (current_pixel >= previous_pixel) ? 
                            (current_pixel - previous_pixel) : 
                            (current_pixel + 256 - previous_pixel);
endmodule