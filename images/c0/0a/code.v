module	memdev(i_clk, i_wb_cyc, i_wb_stb, i_wb_we, i_wb_addr, i_wb_data,
		o_wb_ack, o_wb_stall, o_wb_data);
	parameter	AW=15, DW=32;
	input				i_clk, i_wb_cyc, i_wb_stb, i_wb_we;
	input		[(AW-1):0]	i_wb_addr;
	input		[(DW-1):0]	i_wb_data;
	output	reg			o_wb_ack;
	output	wire			o_wb_stall;
	output	reg	[(DW-1):0]	o_wb_data;
	reg	[(DW-1):0]	mem	[0:((1<<AW)-1)];
	always @(posedge i_clk)
		o_wb_data <= mem[i_wb_addr];
	always @(posedge i_clk)
		if ((i_wb_stb)&&(i_wb_we))
			mem[i_wb_addr] <= i_wb_data;
	always @(posedge i_clk)
		o_wb_ack <= (i_wb_stb);
	assign	o_wb_stall = 1'b0;
endmodule