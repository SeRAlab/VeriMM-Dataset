module top_module (
        input t,
        input u,
        input v,
        output w);assign w = ( ~t & ~u & v ) |
           ( t & ~u & ~v ) |
           ( t & u & v );

endmodule