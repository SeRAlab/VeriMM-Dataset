module tessera_mem_wbif (
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
	write_req,
	write_byte,
	write_address,
	write_data,
	write_ack,
	read_req,
	read_byte,
	read_address,
	read_data,
	read_ack
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
	output		write_req;
	output	[3:0]	write_byte;
	output	[31:0]	write_address;
	output	[31:0]	write_data;
	input		write_ack;
	output		read_req;
	output	[3:0]	read_byte;
	output	[31:0]	read_address;
	input	[31:0]	read_data;
	input		read_ack;
	assign wb_err_o = 1'b0;
	reg		write_ack_z;
	reg		read_ack_z;
	reg		wb_ack;
	always @(posedge clk or posedge res)
		if (res)	write_ack_z <= 1'b0;
		else		write_ack_z <= write_ack;
	always @(posedge clk or posedge res)
		if (res)	read_ack_z <= 1'b0;
		else		read_ack_z <= read_ack;
	always @(posedge clk or posedge res)
		if (res)	wb_ack <= 1'b0;
		else		wb_ack <= (!write_ack_z&&write_ack)||(!read_ack_z&&read_ack); 
	assign wb_ack_o = (wb_cyc_i&&wb_stb_i) ? wb_ack: 1'b0;
	reg	[31:0]	wb_dat;
	always @(posedge clk or posedge res)
		if (res)	wb_dat <= {4{8'h00}};
		else		wb_dat <= read_data;
	assign wb_dat_o = (wb_cyc_i&&wb_stb_i) ? wb_dat[31:0]: {4{8'h00}};
	reg	[3:0]	write_byte;
	reg	[31:0]	write_address;
	reg	[31:0]	write_data;
	reg	[3:0]	read_byte;
	reg	[31:0]	read_address;
	always @(posedge clk or posedge res)
		if (res) begin
			write_byte	<= {4{1'b0}};
			write_address	<= 32'd0;
			write_data	<= {4{8'h00}};
			read_byte	<= {4{1'b0}};
			read_address	<= 32'd0;
		end
		else begin
			write_byte	<= wb_sel_i;
			write_address	<= {8'd0,wb_adr_i[23:0]};
			write_data	<= wb_dat_i;
			read_byte	<= wb_sel_i;
			read_address	<= {8'd0,wb_adr_i[23:0]};
		end
	reg		write_req;
	reg		read_req;
	always @(posedge clk or posedge res)
		if (res)									write_req <= 1'b0;
		else if (write_ack)								write_req <= 1'b0;
		else if (wb_cyc_i && wb_stb_i && !wb_ack_o && !write_ack_z && wb_we_i)		write_req <= 1'b1; 
	always @(posedge clk or posedge res)
		if (res)									read_req <= 1'b0;
		else if (read_ack)								read_req <= 1'b0;
		else if (wb_cyc_i && wb_stb_i && !wb_ack_o && !read_ack_z && !wb_we_i)		read_req <= 1'b1; 
endmodule