module DCT_2x2 (  
    input signed [7:0] pixel_00,  
    input signed [7:0] pixel_01,  
    input signed [7:0] pixel_10,  
    input signed [7:0] pixel_11,  
    output signed [7:0] dct_00,  
    output signed [7:0] dct_01,  
    output signed [7:0] dct_10,  
    output signed [7:0] dct_11  
);  
    // DCT coefficients  
    parameter signed [7:0] C = 64;  
    parameter signed [7:0] S = 0; // Assume no scaling for simplicity  

    assign dct_00 = (pixel_00 + pixel_01 + pixel_10 + pixel_11) >> 2;  
    assign dct_01 = (pixel_00 - pixel_01 + pixel_10 - pixel_11) >> 2;  
    assign dct_10 = (pixel_00 + pixel_01 - pixel_10 - pixel_11) >> 2;  
    assign dct_11 = (pixel_00 - pixel_01 - pixel_10 + pixel_11) >> 2;  
endmodule