module gaussian_blur_3x3 (  
    input [7:0] pixel00,  
    input [7:0] pixel01,  
    input [7:0] pixel02,  
    input [7:0] pixel10,  
    input [7:0] pixel11,  
    input [7:0] pixel12,  
    input [7:0] pixel20,  
    input [7:0] pixel21,  
    input [7:0] pixel22,  
    output reg [7:0] blurred_pixel  
);  
    always @(*) begin  
        blurred_pixel = (pixel00 * 1 + pixel01 * 2 + pixel02 * 1 +  
                         pixel10 * 2 + pixel11 * 4 + pixel12 * 2 +  
                         pixel20 * 1 + pixel21 * 2 + pixel22 * 1) >> 4;  
    end  
endmodule