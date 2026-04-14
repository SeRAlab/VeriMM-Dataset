module top_module (
        input j,
        input k,
        input l,
        output m);assign m = ( ~j & ~k & ~l ) |
           ( ~j & k & ~l ) |
           ( j & ~k & l ) |
           ( j & k & l );

endmodule