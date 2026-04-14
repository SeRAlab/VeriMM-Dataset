module top_module(in,out);input [15:0]in;
	output [31:0]out;
	
	assign out = {in[15] == 0 ? 16'b0 : 16'b1, in};
endmodule