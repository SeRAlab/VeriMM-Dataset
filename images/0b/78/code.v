module bilinear_interpolation (  
    input [7:0] Q11,  
    input [7:0] Q12,  
    input [7:0] Q21,  
    input [7:0] Q22,  
    input [7:0] u,  
    input [7:0] v,  
    output [15:0] P  
);  
    wire [15:0] R1, R2;  
    wire [15:0] temp1, temp2;  

    assign R1 = Q11 * (256 - u) + Q21 * u;  
    assign R2 = Q12 * (256 - u) + Q22 * u;  
    assign temp1 = R1 * (256 - v);  
    assign temp2 = R2 * v;  
    assign P = (temp1 + temp2) >> 8;  
endmodule