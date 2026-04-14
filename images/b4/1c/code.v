module top_module (
        input m,
        input n,
        input o,
        output reg s);assign s = ( ~m & ~n & o ) |
           ( ~m & n & ~o ) |
           ( m & ~n & ~o ) |
           ( m & ~n & o ) |
           ( m & n & o ) ;

endmodule