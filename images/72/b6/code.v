module top_module (
    input m, 
    input n, 
    input p, 
    input q,
    output reg z);assign z = (~m & n & ~p & q) | (m & ~n & p & q) | (~m & n & ~p & ~q) | (m & n & ~p & ~q);

endmodule