module dct_2x2 (  
    input [7:0] pixel0,  
    input [7:0] pixel1,  
    input [7:0] pixel2,  
    input [7:0] pixel3,  
    output reg [15:0] dct0,  
    output reg [15:0] dct1,  
    output reg [15:0] dct2,  
    output reg [15:0] dct3  
);  

    always @(*) begin  
        // DCT coefficients calculation  
        dct0 = (pixel0 + pixel1 + pixel2 + pixel3) * 1;  
        dct1 = (pixel0 - pixel1 + pixel2 - pixel3) * 1;  
        dct2 = (pixel0 + pixel1 - pixel2 - pixel3) * 1;  
        dct3 = (pixel0 - pixel1 - pixel2 + pixel3) * 1;  
    end  
endmodule