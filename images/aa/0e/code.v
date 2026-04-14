module top_module(r, a, b);output[15:0] r;
	input [7:0] a, b;
	wire[15:0] shifted[7:0], sums[7:0];
	assign sums[0] = shifted[0];
	assign r = sums[7];

	genvar i;
	generate
		for(i = 0; i < 8; i = i + 1) begin: shifts
			assign shifted[i] = a<<i & {16{b[i]}};
		end

		for(i = 1; i < 8; i = i + 1) begin: adders
			assign sums[i] = sums[i - 1] + shifted[i];
		end
	endgenerate

endmodule