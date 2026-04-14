module top_module(d0, d1, b, s);input s, d0, d1;
	output b;

	reg out;
	always @*case(s)
		1'b1 : out = d1;
		1'b0 : out = d0;
	endcase

	assign b = out;
endmodule