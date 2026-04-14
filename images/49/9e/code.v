module top_module (
        input u,
        input v,
        input w,
        output reg x);assign x = ( ~u & ~v & w ) |
           ( ~u & v & ~w ) |
           ( u & ~v & ~w ) |
           ( u & v & w ) ;

endmodule