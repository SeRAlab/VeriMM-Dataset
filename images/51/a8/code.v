module top_module(B, A);input [31:0] A;
	output [31:0] B;

	genvar d;
	generate
	for (d=0; d < 28; d = d + 1) begin: lp4
		assign B[d+4] = A[d];
	end
	endgenerate

	genvar e;
	generate
	for (e=0; e < 4; e = e + 1) begin: lp5
		assign B[e] = 1'b0;
	end
	endgenerate
endmodule