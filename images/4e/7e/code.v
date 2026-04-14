module top_module(a,b,g,p);input [3:0] a,b;
    output [3:0] g,p;
    
    
    assign g = a & b;
    assign p = a | b;endmodule