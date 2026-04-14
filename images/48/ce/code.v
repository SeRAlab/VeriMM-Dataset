module top_module(input b_in, 
								input x, 
								input y, 
								output b_out, 
								output dif);assign b_out = ~x & b_in | ~x & y | y & b_in; 
	assign dif = b_in ^ x ^ y;endmodule