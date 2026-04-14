module top_module(in, out);output [15:0] out;
	input  [15:0] in;
	
	assign out = in + 16'd1;

endmodule