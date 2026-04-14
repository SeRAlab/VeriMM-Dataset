module	zipcounter(i_clk, i_ce,
		i_wb_cyc, i_wb_stb, i_wb_we, i_wb_data,
			o_wb_ack, o_wb_stall, o_wb_data,
		o_int);
	parameter	BW = 32;
	input				i_clk, i_ce;
	input				i_wb_cyc, i_wb_stb, i_wb_we;
	input		[(BW-1):0]	i_wb_data;
	output	reg			o_wb_ack;
	output	wire			o_wb_stall;
	output	reg	[(BW-1):0]	o_wb_data;
	output	reg			o_int;
	initial	o_int = 0;
	initial	o_wb_data = 32'h00;
	always @(posedge i_clk)
		if ((i_wb_stb)&&(i_wb_we))
			{ o_int, o_wb_data } <= { 1'b0, i_wb_data };
		else if (i_ce)
			{ o_int, o_wb_data } <= o_wb_data+{{(BW-1){1'b0}},1'b1};
		else
			o_int <= 1'b0;
	initial	o_wb_ack = 1'b0;
	always @(posedge i_clk)
		o_wb_ack <= (i_wb_stb);
	assign	o_wb_stall = 1'b0;
endmodule