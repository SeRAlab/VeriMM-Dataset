module sobel_edge_detection(  
    input [7:0] pixel_0, pixel_1, pixel_2,  
    input [7:0] pixel_3, pixel_4, pixel_5,  
    input [7:0] pixel_6, pixel_7, pixel_8,  
    output [9:0] gradient_magnitude  
);  

    wire signed [15:0] Gx, Gy;  
    wire [15:0] abs_Gx, abs_Gy;  

    assign Gx = (pixel_0 + 2*pixel_1 + pixel_2) - (pixel_6 + 2*pixel_7 + pixel_8);  
    assign Gy = (pixel_0 + 2*pixel_3 + pixel_6) - (pixel_2 + 2*pixel_5 + pixel_8);  

    assign abs_Gx = (Gx < 0) ? -Gx : Gx;  
    assign abs_Gy = (Gy < 0) ? -Gy : Gy;  

    assign gradient_magnitude = abs_Gx + abs_Gy;  

endmodule