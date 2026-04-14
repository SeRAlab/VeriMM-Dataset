module top_module (
        input a,
        input b,
        input c,
        output reg g);assign g = ( ~a & ~b & ~c ) |
				( ~a & ~b & c ) |
				( a & ~b & ~c ) |
				( a & b & ~c ) |
				( a & b & c ) ;

endmodule