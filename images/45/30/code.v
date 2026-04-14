module top_module(a, b, g, p, x, G1, Pr1);input [31:0]a;
    input [31:0]b;
    output [31:0]g;
    output [31:0]p;
    output [31:0]x;
    output [31:0]G1;    
    output [31:0]Pr1;   
    
    assign g[31:0] = a[31:0] & b[31:0] ;
    assign p[31:0] = a[31:0] | b[31:0] ;  
    assign x[31:0] = a[31:0] ^ b[31:0] ;
    
    assign G1[31:0] = g[31:0] | p[31:0] & {g[30:0],g[31]} ;
    assign Pr1[31:0] = p[31:0] & {p[30:0],p[31]} ;endmodule