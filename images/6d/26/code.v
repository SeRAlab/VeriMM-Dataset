module top_module (
        input a1,
        input b1,
        input c1,
        output reg d1);assign d1 = ( ~a1 & ~b1 & ~c1 ) |
				( ~a1 & ~b1 & c1 ) |
				( a1 & ~b1 & ~c1 ) |
				( a1 & ~b1 & c1 ) |
				( a1 & b1 & c1 ) ;

endmodule