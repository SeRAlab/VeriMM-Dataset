module top_module (
        input x1,
        input y1,
        input z1,
        output reg w1);assign w1 = ( ~x1 & ~y1 & ~z1 ) |
				( ~x1 & ~y1 & z1 ) |
				( ~x1 & y1 & z1 ) |
				( x1 & ~y1 & z1 ) |
				( x1 & y1 & z1 ) ;

endmodule