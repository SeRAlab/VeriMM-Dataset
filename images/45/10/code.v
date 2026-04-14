module top_module(
	input			wb_clk,
	input			wb_rst,

	input			wb_adr_i,
	input		[7:0] 	wb_dat_i,
	input			wb_we_i,
	input			wb_cyc_i,
	input			wb_stb_i,
	input		[2:0] 	wb_cti_i,
	input		[1:0]	wb_bte_i,
	output reg	[7:0]	wb_dat_o,
	output reg		wb_ack_o,
	output			wb_err_o,
	output			wb_rty_o,

	input		[7:0]	gpio_i,
	output reg	[7:0]	gpio_o,
	output reg	[7:0]	gpio_dir_o
);always @(posedge wb_clk)
	if (wb_rst)
		gpio_dir_o <= 0; 
	else if (wb_cyc_i & wb_stb_i & wb_we_i) begin
		if (wb_adr_i == 1)
			gpio_dir_o[7:0] <= wb_dat_i;
	end



always @(posedge wb_clk)
	if (wb_rst)
		gpio_o <= 0;
	else if (wb_cyc_i & wb_stb_i & wb_we_i) begin
		if (wb_adr_i == 0)
			gpio_o[7:0] <= wb_dat_i;
	end



always @(posedge wb_clk) begin
	
	if (wb_adr_i == 0)
		wb_dat_o[7:0] <= gpio_i[7:0];

	
	if (wb_adr_i == 1)
		wb_dat_o[7:0] <= gpio_dir_o[7:0];
     end


always @(posedge wb_clk)
	if (wb_rst)
		wb_ack_o <= 0;
	else if (wb_ack_o)
		wb_ack_o <= 0;
	else if (wb_cyc_i & wb_stb_i & !wb_ack_o)
		wb_ack_o <= 1;

assign wb_err_o = 0;
assign wb_rty_o = 0;

endmodule