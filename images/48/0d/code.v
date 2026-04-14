module top_module (
        input p,
        input q,
        input r,
        output reg o);assign o = ( ~p & q & ~r ) |
           ( ~p & q & r ) |
           ( p & ~q & ~r ) |
           ( p & ~q & r ) ;

endmodule