module top_module(
    input x,
    input y,
    output reg out
    );reg p,q;
always @(x,y)
begin

p = (~x & ~y);
q =  x & y;

out = p |q;
end

endmodule