module wbgpio(i_clk, i_wb_cyc, i_wb_stb, i_wb_we, i_wb_data, o_wb_data,
		i_gpio, o_gpio, o_int);
	parameter	NIN=16, NOUT=16, DEFAULT=16'h00;
	input			i_clk;
	input			i_wb_cyc, i_wb_stb, i_wb_we;
	input		[31:0]	i_wb_data;
	output	wire	[31:0]	o_wb_data;
	input		[(NIN-1):0]	i_gpio;
	output	reg	[(NOUT-1):0]	o_gpio;
	output	reg		o_int;
	always @(posedge i_clk)
		if ((i_wb_stb)&&(i_wb_we))
			o_gpio <= ((o_gpio)&(~i_wb_data[(NOUT+16-1):16]))
				|((i_wb_data[(NOUT-1):0])&(i_wb_data[(NOUT+16-1):16]));
	reg	[(NIN-1):0]	x_gpio, r_gpio;
	always @(posedge i_clk)
	begin
		x_gpio <= i_gpio;
		r_gpio <= x_gpio;
		o_int  <= (x_gpio != r_gpio);
	end
	assign	o_wb_data = { {(16-NIN){1'b0}}, r_gpio,
					{(16-NOUT){1'b0}}, o_gpio };
endmodule