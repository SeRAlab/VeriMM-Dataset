module top_module (
        input m,
        input n,
        input o,
        output reg w);assign w = ( ~m & ~n & o ) |
           ( ~m & n & o ) |
           ( m & n & ~o ) ;

endmodule