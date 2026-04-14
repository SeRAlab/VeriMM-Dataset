module top_module (
        input k,
        input l,
        input m,
        output reg n);assign n = ( ~k & ~l & ~m ) |
           ( ~k & ~l & m ) |
           ( k & ~l & ~m ) |
           ( k & ~l & m );

endmodule