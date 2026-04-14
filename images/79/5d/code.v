module top_module(
	din2_din1_nz_hi,
	din2_din1_denorm_hi,
	din2_din1_nz_mid,
	din2_din1_denorm_mid,
	din2_din1_nz_lo,
	din2_din1_denorm_lo,

	din2_din1_nz,
	din2_din1_denorm
);input		din2_din1_nz_hi;	// input 1 and input 2 != 0- high 3 bits
input		din2_din1_denorm_hi;	// input 1 == denorm- high 3 bits
input		din2_din1_nz_mid;	// input 1 and input 2 != 0- mid 3 bits
input		din2_din1_denorm_mid;	// input 1 == denorm- mid 3 bits
input		din2_din1_nz_lo;	// input 1 and input 2 != 0- low 3 bits
input		din2_din1_denorm_lo;	// input 1 == denorm- low 3 bits

output		din2_din1_nz;		// input 1 and input 2 != 0
output		din2_din1_denorm;	// input 1 == denorm

wire		din2_din1_nz;
wire		din2_din1_denorm;

assign din2_din1_nz= din2_din1_nz_hi || din2_din1_nz_mid || din2_din1_nz_lo;

assign din2_din1_denorm= (din2_din1_nz_hi && din2_din1_denorm_hi) || ((!din2_din1_nz_hi) && din2_din1_nz_mid && din2_din1_denorm_mid) || ((!din2_din1_nz_hi) && (!din2_din1_nz_mid) && din2_din1_denorm_lo);

endmodule