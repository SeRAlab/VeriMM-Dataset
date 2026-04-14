module	spiarbiter(i_clk,
		i_cs_a_n, i_ck_a, i_mosi_a,
		i_cs_b_n, i_ck_b, i_mosi_b,
		o_cs_a_n, o_cs_b_n, o_ck, o_mosi,
		o_grant);
	input		i_clk;
	input		i_cs_a_n, i_ck_a, i_mosi_a;
	input		i_cs_b_n, i_ck_b, i_mosi_b;
	output	wire	o_cs_a_n, o_cs_b_n, o_ck, o_mosi;
	output	wire	o_grant; 
	reg	a_owner;
	initial	a_owner = 1'b1;
	always @(posedge i_clk)
		if ((i_cs_a_n)&&(i_cs_b_n))
			a_owner <= 1'b1; 
		else if ((i_cs_a_n)&&(~i_cs_b_n))
			a_owner <= 1'b0; 
		else if ((~i_cs_a_n)&&(i_cs_b_n))
			a_owner <= 1'b1; 
	assign	o_cs_a_n = (~a_owner)||(i_cs_a_n);
	assign	o_cs_b_n = ( a_owner)||(i_cs_b_n);
	assign	o_ck     = ( a_owner)?i_ck_a   : i_ck_b;
	assign	o_mosi   = ( a_owner)?i_mosi_a : i_mosi_b;
	assign	o_grant = ~a_owner;
endmodule