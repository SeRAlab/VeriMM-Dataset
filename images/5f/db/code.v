module top_module(x,y,s,m);input [1:0] x;
    input [1:0] y;
    input s;
    output [1:0] m;
    
    assign #3 m = (s) ? y : x;
endmodule