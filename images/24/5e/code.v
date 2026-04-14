module IFFT_4point (  
    input  [3:0] x0,  
    input  [3:0] x1,  
    input  [3:0] x2,  
    input  [3:0] x3,  
    output reg [3:0] y0,  
    output reg [3:0] y1,  
    output reg [3:0] y2,  
    output reg [3:0] y3  
);  

    always @(*) begin  
        // Inverse FFT calculation using predefined formula for 4-point IFFT  
        y0 = (x0 + x1 + x2 + x3) >> 2;  
        y1 = (x0 + (x1 << 1) + (x2 << 1) - x3) >> 2;  
        y2 = (x0 - x1 + x2 - x3) >> 2;  
        y3 = (x0 - (x1 << 1) + (x2 << 1) + x3) >> 2;  
    end  
endmodule