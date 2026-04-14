module top_module(p,x,R1,Q1,xD);input [15:0]p;
    input [15:0]x;
    input [15:0]R1;
    input [15:0]Q1;    
    output [15:0]xD;
    
    wire [15:0]D ;
    
    
    assign D[15:0] =    p[15:0] & R1[15:0] |
                        {p[11:0],p[15:12]} & Q1[15:0] ;
    
    assign xD[15:0] = {D[14:0],D[15]} ^ x[15:0] ;endmodule