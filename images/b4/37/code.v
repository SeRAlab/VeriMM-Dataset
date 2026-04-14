module top_module(a, b, g, p, G1, Pr1);input [15:0]a;
    input [15:0]b;
    output [15:0]g;
    output [15:0]p;
    output [15:0]G1;    
    output [15:0]Pr1;   
    
    assign g[15:0] = a[15:0] & b[15:0] ;
    assign p[15:0] = a[15:0] | b[15:0] ;  

    assign G1[15:0] = g[15:0] | p[15:0] & {g[14:0],g[15]} ;
    assign Pr1[15:0] = p[15:0] & {p[14:0],p[15]} ;endmodule