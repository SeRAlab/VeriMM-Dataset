module top_module (
        input g,
        input h,
        input i,
        output reg j);assign j = ( ~g & ~h & i ) |
           ( ~g & h & ~i ) |
           ( g & ~h & ~i ) |
           ( g & h & i ) ;

endmodule