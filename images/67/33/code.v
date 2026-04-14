module top_module (
        input x,
        input y,
        input z,
        output reg p);assign p = ( ~x & ~y & z ) |
           ( ~x & y & ~z ) |
           ( ~x & y & z ) |
           ( x & ~y & ~z ) |
           ( x & ~y & z ) |
           ( x & y & ~z ) ;

endmodule