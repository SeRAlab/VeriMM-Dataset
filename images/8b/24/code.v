module top_module(x,y,s,m);input x,y,s;
    output reg m;
    
    always @( x or y or s) 
    begin
        m = #3 (~s & x) | (s & y);
    end
endmodule