module bilinear_interpolation(  
    input [7:0] Q11, // Pixel value 1  
    input [7:0] Q12, // Pixel value 2  
    input [7:0] Q21, // Pixel value 3  
    input [7:0] Q22, // Pixel value 4  
    input [7:0] x_frac, // Fractional part in x direction (0-255)  
    input [7:0] y_frac, // Fractional part in y direction (0-255)  
    output [7:0] Q_interp // Interpolated pixel value  
);  
    wire [15:0] Q1, Q2;  
    wire [15:0] Q1_weighted, Q2_weighted;  
    wire [15:0] Q_interp_temp;  

    // Compute Q1 and Q2 using the weights of the fractional parts  
    assign Q1 = (Q11 * (255 - x_frac) + Q21 * x_frac) >> 8;  
    assign Q2 = (Q12 * (255 - x_frac) + Q22 * x_frac) >> 8;  

    // Final interpolation between Q1 and Q2  
    assign Q_interp = (Q1 * (255 - y_frac) + Q2 * y_frac) >> 8;  
endmodule