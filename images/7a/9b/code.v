module top_module(a, lsb, out);input [31:0] a;
	input lsb;
	output[31:0] out;
	wire [31:0] out;
	
	genvar i;
	generate
		for(i=8; i<32; i=i+1) begin: shift_eight_loop
			assign out[i] = a[i-8];
		end
	endgenerate
	
	genvar j;
	generate
		for(j=0; j<8; j=j+1) begin: shift_eight_sub_loop
			assign out[j] = lsb;
		end
	endgenerate

endmodule