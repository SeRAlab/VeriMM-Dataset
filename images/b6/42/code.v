module logic_spec (
    input x, 
    input y, 
    input z, 
    input w,
    output reg result);assign result = (~x & y & ~z & w) | (~x & ~y & z & w) | (x & y & z & w) | (x & y & ~z & w);

endmodule