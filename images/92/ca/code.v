module top_module(x,y,s,m);input [1:0] x, y;
    input s;
    output reg [1:0] m;
    
    always @( x or y or s)
    begin
        m[0] = #3 (~s & x[0]) | (s & y[0]);
        m[1] = #3 (~s & x[1]) | (s & y[1]);
    end
endmodule