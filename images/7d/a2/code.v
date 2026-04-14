module top_module (
	input w, 
	input x, 
	input y, 
	output reg z);assign z = (w & ~x & ~y) | (~w & x & ~y) | (~w & ~x & y);
	
endmodule