module bw_r_irf_72_4x1_mux(sel, y, x0, x1, x2, x3);
	input	[1:0]	sel;
	input	[71:0]	x0;
	input	[71:0]	x1;
	input	[71:0]	x2;
	input	[71:0]	x3;
	output	[71:0] y;
	reg	[71:0] y;
	always @(sel or x0 or x1 or x2 or x3)
		case(sel)
		  2'b00: y = x0;
		  2'b01: y = x1;
		  2'b10: y = x2;
		  2'b11: y = x3;
		endcase
endmodule