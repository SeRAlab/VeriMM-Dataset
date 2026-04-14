module top_module (
        input x,
        input y,
        input z,
        output reg r);assign r = ( ~x & ~y & ~z ) |
           ( ~x & y & ~z ) |
           ( x & y & z ) |
           ( x & ~y & z ) ;

endmodule