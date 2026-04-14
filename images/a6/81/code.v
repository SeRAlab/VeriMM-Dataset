module top_module(in,out);parameter bits_in=0;  
	parameter bits_out=0;
	
	input [bits_in-1:0] in;
	output [bits_out-1:0] out;
	
	assign out = {{(bits_out-bits_in){in[bits_in-1]}},in};
	
endmodule