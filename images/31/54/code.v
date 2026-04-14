module PNG_Sub_Filter (
    input [7:0] current_pixel,
    input [7:0] left_pixel,
    output [7:0] filtered_pixel
);
    assign filtered_pixel = current_pixel - left_pixel;
endmodule