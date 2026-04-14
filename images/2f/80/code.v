module bilinear_interp (  
    input [7:0] Q11,  
    input [7:0] Q12,  
    input [7:0] Q21,  
    input [7:0] Q22,  
    input [7:0] dx,  
    input [7:0] dy,  
    output [7:0] Q_interpolated  
);  

    wire [15:0] Q1, Q2, Q3, Q4;  

    // Intermediate calculations  
    assign Q1 = Q11 * (256 - dx) + Q21 * dx;  
    assign Q2 = Q12 * (256 - dx) + Q22 * dx;  
    assign Q3 = Q1 * (256 - dy);  
    assign Q4 = Q2 * dy;  

    // Final interpolation  
    assign Q_interpolated = (Q3 + Q4) >> 8;  

endmodule