module lu_decomposition (
    input [7:0] a11, a12, 
    input [7:0] a21, a22,
    output [7:0] l11, l21, l22,
    output [7:0] u11, u12, u21, u22
);
    assign l11 = a11;
    assign l21 = a21 * l11 / a11; 
    assign l22 = a22 - l21 * u12;  

    assign u11 = a11; 
    assign u12 = a12; 
    assign u21 = 0; 
    assign u22 = a22 - (l21 * u12); 
endmodule