module top_module (
        input t,
        input u,
        input v,
        output reg s);assign s = ( ~t & ~u & v ) |
           ( ~t & u & ~v ) |
           ( t & ~u & ~v ) |
           ( t & u & ~v ) ;

endmodule