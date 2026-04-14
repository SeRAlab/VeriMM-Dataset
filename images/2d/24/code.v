module LU_Decomposition (  
    input wire [7:0] a,  
    input wire [7:0] b,  
    input wire [7:0] c,  
    input wire [7:0] d,  
    output wire [7:0] l11,  
    output wire [7:0] l21,  
    output wire [7:0] u11,  
    output wire [7:0] u12,  
    output wire [7:0] u22  
);  
    assign l11 = a;  
    assign l21 = c / a;  
    assign u11 = a;  
    assign u12 = b;  
    assign u22 = d - (l21 * u12);  
endmodule