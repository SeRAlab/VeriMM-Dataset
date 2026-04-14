module LU_decomposition (  
    input [3:0] a,  
    input [3:0] b,  
    input [3:0] c,  
    input [3:0] d,  
    output [3:0] L11,  
    output [3:0] L12,  
    output [3:0] U11,  
    output [3:0] U12  
);  
    assign U11 = a;  
    assign U12 = b;  
    assign L11 = 4'b0001; // L11 is always 1  
    assign L12 = c / U11; // L12 = c / U11  
endmodule