module top_module(a, b, g, p, R1, Q1);input [15:0]a ;
    input [15:0]b ;
    output [15:0]g ;
    output [15:0]p ;
    output [15:0]R1 ;
    output [15:0]Q1 ;
    
    
    
    assign p[15:0] = a[15:0] | b[15:0] ;
    
    
    assign g[15:0] = a[15:0] & b[15:0] ;
    
    
    assign R1[15:0] = g[15:0] | {g[14:0],g[15]};
    
    
    assign Q1[15:0] = p[15:0] & {p[14:0],p[15]} ;endmodule