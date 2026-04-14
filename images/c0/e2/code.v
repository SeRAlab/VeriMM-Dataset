module tessera_vga_wbif (
	res,
	clk,
	wb_cyc_i,
	wb_stb_i,
	wb_adr_i,
	wb_sel_i,
	wb_we_i,
	wb_dat_i,
	wb_cab_i,
	wb_dat_o,
	wb_ack_o,
	wb_err_o,
	enable,
	base
);
	input		res;
	input		clk;
	input		wb_cyc_i;
	input		wb_stb_i;
	input	[31:0]	wb_adr_i;
	input	[3:0]	wb_sel_i;
	input		wb_we_i;
	input	[31:0]	wb_dat_i;
	input		wb_cab_i;
	output	[31:0]	wb_dat_o;
	output		wb_ack_o;
	output		wb_err_o;
	output		enable;
	output	[23:11]	base;
	reg	[31:0]	reg1;		
	reg	[31:0]	reg0;		
	assign wb_err_o = 1'b0;
	wire		active;
	wire		write;
	wire		read;
	assign active	= wb_cyc_i&&wb_stb_i;
	assign write	= active &&  wb_we_i;
	assign read	= active && !wb_we_i;
	always @(posedge clk or posedge res)
		if (res) begin
			reg0 <= 32'h0000_0000;
			reg1 <= 32'h0000_0000;
		end
		else if (write) begin
			if (wb_adr_i[2]==1'd1) begin
				if (wb_sel_i[3]) reg1[31:24] <= wb_dat_i[31:24];
				if (wb_sel_i[2]) reg1[23:16] <= wb_dat_i[23:16];
				if (wb_sel_i[1]) reg1[15: 8] <= wb_dat_i[15: 8];
				if (wb_sel_i[0]) reg1[ 7: 0] <= wb_dat_i[ 7: 0];
			end 
			else if (wb_adr_i[2]==1'd0) begin
				if (wb_sel_i[3]) reg0[31:24] <= wb_dat_i[31:24];
				if (wb_sel_i[2]) reg0[23:16] <= wb_dat_i[23:16];
				if (wb_sel_i[1]) reg0[15: 8] <= wb_dat_i[15: 8];
				if (wb_sel_i[0]) reg0[ 7: 0] <= wb_dat_i[ 7: 0];
			end
		end
	assign wb_dat_o = (read) ? (
				(wb_adr_i[2]==1'd0) ? reg0:
				(wb_adr_i[2]==1'd1) ? reg1:
				32'h0000_0000
			):  32'h0000_0000;
	assign wb_ack_o = active;
	assign enable = reg1[0];
	assign base = reg0[23:11];
endmodule