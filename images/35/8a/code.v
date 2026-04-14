module dct_2x2 (  
    input [3:0] pixel0,  
    input [3:0] pixel1,  
    input [3:0] pixel2,  
    input [3:0] pixel3,  
    output [3:0] dct0,  
    output [3:0] dct1,  
    output [3:0] dct2,  
    output [3:0] dct3  
);  
    assign dct0 = (pixel0 + pixel1 + pixel2 + pixel3) >> 2;  
    assign dct1 = (pixel0 - pixel1 + pixel2 - pixel3) >> 2;  
    assign dct2 = (pixel0 + pixel1 - pixel2 - pixel3) >> 2;  
    assign dct3 = (pixel0 - pixel1 - pixel2 + pixel3) >> 2;  
endmodule