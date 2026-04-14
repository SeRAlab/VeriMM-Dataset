module top_module (
        input p,
        input q,
        input r,
        output reg h);assign h = ( ~p & ~q & ~r ) |
				( ~p & q & ~r ) |
				( p & ~q & ~r ) |
				( p & q & r ) ;

endmodule