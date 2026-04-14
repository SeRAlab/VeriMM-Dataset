module gaussian_blur(  
    input [8:0] pixel_0, pixel_1, pixel_2,  
    input [8:0] pixel_3, pixel_4, pixel_5,  
    input [8:0] pixel_6, pixel_7, pixel_8,  
    output reg [8:0] blurred_pixel  
);  
    always @(*) begin  
        blurred_pixel = (pixel_0 + pixel_1 + pixel_2 +  
                         pixel_3 + (2 * pixel_4) + pixel_5 +  
                         pixel_6 + pixel_7 + pixel_8) / 16;  
    end  
endmodule