module top_module (
        input f,
        input g,
        input h,
        output reg m);assign m = ( ~f & ~g & ~h ) |
				( ~f & ~g & h ) |
				( f & ~g & ~h ) |
				( f & g & h ) ;

endmodule