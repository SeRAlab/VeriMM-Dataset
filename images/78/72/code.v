module top_module(d, ena, n, g);input [7:0] d;
	input ena;
	output [2:0] n;
	output g;
	
	assign g = ena & |d;			
									
	assign n = enc(ena, d);			
	
	function [2:0] enc;
		input ena;
		input [7:0] d;
		
		case ({ena, d})
		
			9'b1_1xxxxxx: enc = 3'd7;	
			9'b1_01xxxxx: enc = 3'd6;	
			9'b1_001xxxx: enc = 3'd5;
			9'b1_0001xxx: enc = 3'd4;
			9'b1_00001xx: enc = 3'd3;
			9'b1_000001x: enc = 3'd2;
			9'b1_0000001: enc = 3'd1;	
			default:	  enc = 3'd0;
		
		endcase
		
	endfunction
	

endmodule