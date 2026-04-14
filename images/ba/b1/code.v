module top_module(
input	[3:0]	hex,
output	[6:0]	hex_fps
);assign hex_fps	=	(hex == 4'd0) ? 7'h40: 
					(hex == 4'd1) ? 7'h79: 
					(hex == 4'd2) ? 7'h24: 
					(hex == 4'd3) ? 7'h30: 
					(hex == 4'd4) ? 7'h19: 
					(hex == 4'd5) ? 7'h12: 
					(hex == 4'd6) ? 7'h02: 
					(hex == 4'd7) ? 7'h78: 
					(hex == 4'd8) ? 7'h00: 
									7'h10; 

endmodule