module top_module(
    input [3:0] bcd_in,
    output reg [7:0] ascii_out
    );parameter 	ASCII_OFFSET = 8'h30;
    parameter 	PLUS_SIGN = 8'h2B,
    			MINUS_SIGN = 8'h2D,
    			EQUAL_SIGN = 8'h3D;
    
    
    always @ (*)
    	case ({4'h0, bcd_in} + ASCII_OFFSET)
    		8'h3a:	ascii_out = PLUS_SIGN;
    		8'h3b:	ascii_out = MINUS_SIGN;
    		8'h3d:	ascii_out = EQUAL_SIGN;
    		default: ascii_out = {4'h0, bcd_in} + ASCII_OFFSET;
    	endcase
endmodule