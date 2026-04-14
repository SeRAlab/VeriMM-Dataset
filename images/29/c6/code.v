module BilinearInterpolation(  
    input [7:0] Q11, // pixel value at (x1, y1)  
    input [7:0] Q12, // pixel value at (x1, y2)  
    input [7:0] Q21, // pixel value at (x2, y1)  
    input [7:0] Q22, // pixel value at (x2, y2)  
    input [7:0] x,    // fractional x coordinate (0-255)  
    input [7:0] y,    // fractional y coordinate (0-255)  
    output [7:0] P    // interpolated pixel value  
);  
    wire [15:0] R1, R2;  
    wire [15:0] R1_int, R2_int;  
    wire [15:0] x_fraction, y_fraction;  

    assign x_fraction = {8'b0, x};  
    assign y_fraction = {8'b0, y};  

    assign R1 = (Q11 * (256 - x) + Q21 * x) >> 8;  
    assign R2 = (Q12 * (256 - x) + Q22 * x) >> 8;  
    assign P = (R1 * (256 - y) + R2 * y) >> 8;  
endmodule