module sobel_edge_detection(  
    input [8:0] pixel_values,  
    output reg [9:0] gradient_magnitude  
);  
    wire signed [9:0] Gx, Gy;  
    wire signed [9:0] G;  

    // Sobel Gx kernel
    assign Gx = (pixel_values[2] + 2 * pixel_values[5] + pixel_values[8]) - (pixel_values[0] + 2 * pixel_values[3] + pixel_values[6]);  
    // Sobel Gy kernel
    assign Gy = (pixel_values[0] + 2 * pixel_values[1] + pixel_values[2]) - (pixel_values[6] + 2 * pixel_values[7] + pixel_values[8]);  

    // Gradient magnitude calculation
    assign G = Gx + Gy;  
    always @(*) begin  
        if (G < 0)  
            gradient_magnitude = 0;  
        else if (G > 1023)  
            gradient_magnitude = 1023;  
        else  
            gradient_magnitude = G;  
    end  
endmodule