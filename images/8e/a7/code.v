module top_module(current_x, current_y, clk27, rst27,
			  nleft, nright, nup, ndown, model_r,
	          model_g, model_b);input [9:0] current_x, current_y;
input nleft, nright, nup, ndown;
input clk27, rst27;

output [3:0] model_r, model_g, model_b;

assign model_r = current_x; 
assign model_g = current_x; 
assign model_b = current_x; 

endmodule