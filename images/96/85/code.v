module top_module(output Q, Qn, input clr_l, pre_l, D, clk);wire [3:0]n_out; 

	
	nand 	lnand0(n_out[0], pre_l, n_out[1], n_out[3]),
		lnand1(n_out[1], n_out[0], clk, clr_l),
		lnand2(n_out[2], n_out[1], clk, n_out[3]),
		lnand3(n_out[3], D, n_out[2], clr_l);

	
	nand    unand0(Q, n_out[1], pre_l, Qn),
		unand1(Qn, n_out[2], Q, clr_l);

endmodule