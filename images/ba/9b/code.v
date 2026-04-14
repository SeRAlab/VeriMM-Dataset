module functionality_module (
    input m, 
    input n, 
    input o, 
    input p,
    output reg out);assign out = (~m & ~n & o & p) | (m & n & o & ~p) | (m & n & o & p) | (~m & n & o & p);

endmodule