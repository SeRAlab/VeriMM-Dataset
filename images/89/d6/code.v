module top_module(n_LL, n_POUT, n_LU);input [1:0] n_LL;
	input n_POUT;
	output [3:0] n_LU;

	wire [1:0] LL;
	assign LL = ~n_LL;

	or (n_LU[3], n_LL[0], n_LL[1], n_POUT);
	or (n_LU[2], LL[0], n_LL[1], n_POUT);
	or (n_LU[1], n_LL[0], LL[1], n_POUT);
	or (n_LU[0], LL[0], LL[1], n_POUT);endmodule