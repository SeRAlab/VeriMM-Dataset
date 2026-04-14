module top_module(out,in);input[31:0] in;
	output[31:0] out;
	
	genvar c;
	
	generate
		for (c = 1; c <= 31; c = c + 1) begin: loop1
			assign out[c-1] = in[c];
		end
	endgenerate
	
	genvar d;
	
	
	assign out[31] = in[31];
		

endmodule