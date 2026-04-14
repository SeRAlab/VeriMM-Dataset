module top_module(a, b, out);input [31:0] a, b;
	output [31:0] out;
	wire [31:0] out;
	
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin: and_loop
			and(out[i], a[i], b[i]);
		end
	endgenerate

endmodule