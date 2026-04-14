module top_module (
        input x,
        input y,
        input z,
        output w);assign w = ( ~x & ~y & z ) |
           ( ~x & y & z ) |
           ( x & ~y & ~z ) |
           ( x & y & ~z ) ;

endmodule