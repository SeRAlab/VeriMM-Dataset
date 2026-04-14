module top_module(a, b, c_in, s, c_out);input a, b, c_in;
	output s, c_out;
	
	assign s = c_in ^ b ^ a; 
	assign c_out = (b&a) | (c_in&b) | (c_in&a);endmodule