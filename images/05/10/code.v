module image_convolution(  
    input [8:0] pixel00,  
    input [8:0] pixel01,  
    input [8:0] pixel02,  
    input [8:0] pixel10,  
    input [8:0] pixel11,  
    input [8:0] pixel12,  
    input [8:0] pixel20,  
    input [8:0] pixel21,  
    input [8:0] pixel22,  
    output reg [8:0] output_pixel  
);  
    always @(*) begin  
        output_pixel = (pixel00 + pixel01 + pixel02 +  
                        pixel10 + pixel11 + pixel12 +  
                        pixel20 + pixel21 + pixel22) / 9;  
    end  
endmodule