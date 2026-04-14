module top_module (
        input a,
        input b,
        input c,
        output d);assign d = ( ~a & b & ~c ) |
           ( ~a & b & c ) |
           ( a & ~b & ~c );

endmodule