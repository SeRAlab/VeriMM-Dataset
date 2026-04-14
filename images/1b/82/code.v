module gaussian_blur(  
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

always @* begin  
    // Gaussian weights:  
    // 1 2 1  
    // 2 4 2  
    // 1 2 1  
    // Normalization factor: 16  
    blurred_pixel = (pixel00 + pixel01*2 + pixel02 +  
                     pixel10*2 + pixel11*4 + pixel12*2 +  
                     pixel20 + pixel21*2 + pixel22) / 16;  
end  
endmodule