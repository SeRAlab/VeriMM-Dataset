module LU_Decomposition(  
    input [1:0] a,  
    input [1:0] b,  
    output reg [1:0] l11,  
    output reg [1:0] l21,  
    output reg [1:0] u11,  
    output reg [1:0] u12,  
    output reg [1:0] u21,  
    output reg [1:0] u22  
);  

    always @* begin  
        l11 = a;  
        l21 = b / a; // Assumes a is non-zero  
        u11 = a;  
        u12 = b - (l21 * u11);  
        u21 = 0;  
        u22 = 0;  
    end  
endmodule