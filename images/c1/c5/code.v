module	spio(i_clk, i_wb_cyc, i_wb_stb, i_wb_we, i_wb_data, o_wb_data,
	o_kp_col, i_kp_row, i_btn, o_led,
	o_kp_int, o_btn_int);
	input			i_clk;
	input			i_wb_cyc, i_wb_stb, i_wb_we;
	input		[31:0]	i_wb_data;
	output	wire	[31:0]	o_wb_data;
	output	reg	[3:0]	o_kp_col;
	input		[3:0]	i_kp_row;
	input		[1:0]	i_btn;
	output	reg	[3:0]	o_led;
	output	reg		o_kp_int, o_btn_int;
	initial	o_kp_col = 4'h0;
	initial	o_led    = 4'h0;
	always @(posedge i_clk)
		if ((i_wb_stb)&&(i_wb_we))
		begin
			o_kp_col <= ((o_kp_col)&(~i_wb_data[11:8]))
					|((i_wb_data[15:12])&(i_wb_data[11:8]));
			o_led[0] <= (i_wb_data[4])?i_wb_data[0]:o_led[0];
			o_led[1] <= (i_wb_data[5])?i_wb_data[1]:o_led[1];
			o_led[2] <= (i_wb_data[6])?i_wb_data[2]:o_led[2];
			o_led[3] <= (i_wb_data[7])?i_wb_data[3]:o_led[3];
		end
	reg	[3:0]	x_kp_row, r_kp_row;
	reg	[1:0]	x_btn, r_btn;
	initial	x_kp_row  = 4'h0;
	initial	r_kp_row  = 4'b0;
	initial	x_btn     = 2'b0;
	initial	r_btn     = 2'b0;
	initial	o_kp_int  = 1'b0;
	initial	o_btn_int = 1'b0;
	always @(posedge i_clk)
	begin
		x_kp_row <= i_kp_row;
		x_btn    <= i_btn;
		r_kp_row <= x_kp_row;
		r_btn    <= x_btn;
		o_kp_int <= ~(&r_kp_row);
		o_btn_int <= |(r_btn);
	end
	assign	o_wb_data = { 16'h00, o_kp_col, r_kp_row, 2'b00, r_btn, o_led };
endmodule