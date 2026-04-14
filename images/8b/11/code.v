module top_module (
        input m,
        input n,
        input o,
        output p);assign p = ( ~m & ~n & ~o ) |
           ( ~m & ~n & o ) |
           ( m & ~n & o );

endmodule