module top_module(in, out);input[31:0] in;
	output[31:0] out;
	
	or or1(out[31], in[31], 1'b0);
	or or2(out[30], in[31], 1'b0);
	or or3(out[29], in[31], 1'b0);
	or or4(out[28], in[31], 1'b0);
	
	genvar i;
	
	generate
		for (i = 27; i >= 0; i = i -1 ) begin: loop1
			or ori(out[i], in[i+4], 1'b0);
		end
	endgenerate
	
endmodule