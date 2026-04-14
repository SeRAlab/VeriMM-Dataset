module top_module(x, y, s, m);input x; 
	input y; 
	input s; 
	output m; 
  
 	assign m = s & y | ~s & x;endmodule