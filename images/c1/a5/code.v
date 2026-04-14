module	zipjiffies(i_clk, i_ce,
		i_wb_cyc, i_wb_stb, i_wb_we, i_wb_data,
			o_wb_ack, o_wb_stall, o_wb_data,
		o_int);
	parameter	BW = 32;
	input				i_clk, i_ce;
	input				i_wb_cyc, i_wb_stb, i_wb_we;
	input		[(BW-1):0]	i_wb_data;
	output	reg			o_wb_ack;
	output	wire			o_wb_stall;
	output	wire	[(BW-1):0]	o_wb_data;
	output	reg			o_int;
	reg	[(BW-1):0]	r_counter;
	always @(posedge i_clk)
		if (i_ce)
			r_counter <= r_counter+1;
	reg				int_set,  new_set;
	reg		[(BW-1):0]	int_when, new_when;
	wire	signed	[(BW-1):0]	till_when, till_wb;
	assign	till_when = int_when-r_counter;
	assign	till_wb   = new_when-r_counter;
	initial	new_set = 1'b0;
	always @(posedge i_clk)
	begin
		new_set <= ((i_wb_cyc)&&(i_wb_stb)&&(i_wb_we));
		new_when<= i_wb_data;
	end
	initial	o_int   = 1'b0;
	initial	int_set = 1'b0;
	always @(posedge i_clk)
	begin
		o_int <= 1'b0;
		if ((i_ce)&&(int_set)&&(r_counter == int_when))
			o_int <= 1'b1;	
		else if ((new_set)&&(till_wb <= 0))
			o_int <= 1'b1;
		if ((new_set)&&(till_wb > 0))
			int_set <= 1'b1;
		else if ((i_ce)&&(r_counter == int_when))
			int_set <= 1'b0;
		if ((new_set)&&(till_wb > 0)&&((till_wb<till_when)||(~int_set)))
			int_when <= new_when;
	end
	always @(posedge i_clk)
		o_wb_ack <= (i_wb_cyc)&&(i_wb_stb);
	assign	o_wb_data = r_counter;
	assign	o_wb_stall = 1'b0;
endmodule