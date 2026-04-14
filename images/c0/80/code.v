module bw_r_irf_72_2x1_mux(sel, y, x0, x1);
	input		sel;
	input	[71:0]	x0;
	input	[71:0]	x1;
	output	[71:0] y;
	reg	[71:0] y;
	always @(sel or x0 or x1)
		case(sel)
		  1'b0: y = x0;
		  1'b1: y = x1;
		endcase
endmodule