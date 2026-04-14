module png_filter_sub (  
    input [7:0] current_pixel,  
    input [7:0] previous_pixel,  
    output [7:0] filtered_pixel  
);  
    assign filtered_pixel = (previous_pixel == 8'b0) ? current_pixel : current_pixel - previous_pixel;  
endmodule