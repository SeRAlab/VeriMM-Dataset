module top_module(in , out);input [4:0] in;
	output out;
	
	assign out = ~in[4] & ~in[3] & in[2] & ~in[1] & ~in[0];endmodule