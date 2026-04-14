module top_module(x_1, y_1, x_2, y_2, collision);input [2:0] x_1;
	input [2:0] y_1;
	input [2:0] x_2;
	input [2:0] y_2;
	
	output collision;
	
	assign collision = (x_1 == x_2) && (y_1 == y_2);endmodule