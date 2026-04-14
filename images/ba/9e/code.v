module top_module (
	input [6:0] e,
	output [6:0] rotate_left,
	output [6:0] rotate_right);assign rotate_left = {e[5:0], e[6]};
	assign rotate_right = {e[0], e[6:1]};
	
endmodule