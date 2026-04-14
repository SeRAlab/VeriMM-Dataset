module png_filter(  
    input [7:0] current_pixel,  
    input [7:0] left_pixel,  
    input [7:0] top_pixel,  
    output [7:0] filtered_pixel  
);  
assign filtered_pixel = (current_pixel + left_pixel + top_pixel) / 3;  
endmodule