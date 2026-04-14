module top_module(a, b, g, p, x);input [31:0]a;
    input [31:0]b;
    output [31:0]g;
    output [31:0]p;
    output [31:0]x;

    
    assign g[31:0] = a[31:0] & b[31:0] ;
    assign p[31:0] = a[31:0] | b[31:0] ;  
    assign x[31:0] = a[31:0] ^ b[31:0] ;endmodule