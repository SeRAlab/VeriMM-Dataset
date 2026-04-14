module top_module(in, out, enable, shiftedOff);input [63:0] in;
	input enable;
	output shiftedOff;
	output [63:0] out;
	
	assign out[63] = in[63];
	
	genvar i;
	generate
		for (i = 62; i >= 0; i = i - 1) begin: loop1
			assign out[i] = (in[i+1] & enable) | (in[i] & ~enable);
		end
	endgenerate
	assign shiftedOff = in[0];endmodule