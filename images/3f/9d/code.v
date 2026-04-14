module sobel_filter (  
    input [7:0] pixel00, pixel01, pixel02,  
    input [7:0] pixel10, pixel11, pixel12,  
    input [7:0] pixel20, pixel21, pixel22,  
    output reg [7:0] gradient  
);  
    wire signed [16:0] Gx;  
    wire signed [16:0] Gy;  

    // Sobel kernels  
    assign Gx = (pixel00 * -1) + (pixel01 * 0) + (pixel02 * 1) +  
                (pixel10 * -2) + (pixel11 * 0) + (pixel12 * 2) +  
                (pixel20 * -1) + (pixel21 * 0) + (pixel22 * 1);  

    assign Gy = (pixel00 * -1) + (pixel01 * -2) + (pixel02 * -1) +  
                (pixel10 * 0) + (pixel11 * 0) + (pixel12 * 0) +  
                (pixel20 * 1) + (pixel21 * 2) + (pixel22 * 1);  

    // Calculate the gradient magnitude  
    always @(*) begin  
        gradient = (Gx * Gx + Gy * Gy) ** 0.5; // Could also use a simpler approximation  
    end  
endmodule