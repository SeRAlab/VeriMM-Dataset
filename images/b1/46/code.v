module top_module(A, B, notEqual);input[31:0] A, B;
	output notEqual;
	wire[31:0] xor_out;
	wire[31:0] compare_xorout;

	
	genvar i;
	generate
	for (i=0; i<32; i=i+1) begin: begin_xor
		xor xor1(xor_out[i], A[i], B[i]);
	end
	endgenerate
	
	
	assign compare_xorout[0] = xor_out[0];
	genvar j;
	generate
	for (j=1; j<32; j=j+1) begin: begin_or
		or or1(compare_xorout[j], compare_xorout[j-1], xor_out[j]);
	end
	endgenerate
	
	assign notEqual= (compare_xorout[31] == 1) ? 1 : 0;
	
endmodule