module top_module (
        input a,
        input b,
        input c,
        output reg h);assign h = ( ~a & ~b & c ) |
           ( ~a & b & ~c ) |
           ( a & ~b & ~c ) |
           ( a & b & c ) ;

endmodule