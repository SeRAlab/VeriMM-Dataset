module top_module(a, b, g, p, x);input [15:0]a;
    input [15:0]b;
    output [15:0]g;
    output [15:0]p;
    output [15:0]x;
    
    assign g[15:0] = a[15:0] & b[15:0] ;
    assign p[15:0] = a[15:0] | b[15:0] ;  
    assign x[15:0] = a[15:0] ^ b[15:0];endmodule