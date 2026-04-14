module top_module (
        input q,
        input r,
        input s,
        output reg t);assign t = ( ~q & ~r & ~s ) |
           ( ~q & ~r & s ) |
           ( ~q & r & s ) |
           ( q & r & s ) ;

endmodule