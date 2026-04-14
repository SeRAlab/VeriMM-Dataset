module top_module (
        input s,
        input t,
        input u,
        output reg k);assign k = ( ~s & ~t & u ) |
				( ~s & t & u ) |
				( s & ~t & ~u ) |
				( s & t & ~u ) ;

endmodule