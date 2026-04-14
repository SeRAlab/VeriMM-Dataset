module top_module (
        input m,
        input n,
        input o,
        output reg j);assign j = ( ~m & ~n & o ) |
				( ~m & n & ~o ) |
				( m & ~n & o ) |
				( m & n & o ) ;

endmodule