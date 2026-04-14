module top_module(

	
	input											clk_i,						
	input											reset_n_i,					
	
	
	input 										spi_busy_i,
	input											trans_start_i,
	input											rx_empty_i,
	input											tx_full_i,
	
	
	output			[31:0]					reg_control_o,
	output			[31:0]					reg_trans_ctrl_o,
	output			[31:0]					reg_status_o,
	
	input			   [31:0]					reg_data_i,
	input											reg_load_i,
	input			   [1:0]						reg_sel_i
);reg [11:0] axi_spi_ctrl_reg;
	
	always @ (posedge clk_i, negedge reset_n_i)
	begin
		if (!reset_n_i)
		begin
			axi_spi_ctrl_reg <= 32'd1;
		end
		else
			if (reg_load_i & (reg_sel_i == 2'b0))
			begin
				axi_spi_ctrl_reg[10:8] <= reg_data_i[10:8];
				axi_spi_ctrl_reg[3:0] <= reg_data_i[3:0];
			end
	end;
	
	assign reg_control_o = {21'd0, axi_spi_ctrl_reg};
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	reg [13:0] trans_ctrl_reg;
	
	always @ (posedge clk_i, negedge reset_n_i)
	begin
		if (!reset_n_i)
		begin
			trans_ctrl_reg <= 14'd0;
		end
		else
			if (trans_start_i)
			begin
				trans_ctrl_reg <= trans_ctrl_reg &14'b01_1111_1111_1111;
			end
			else if (reg_load_i & (reg_sel_i == 2'b1))
			begin
				trans_ctrl_reg[3:0] <= reg_data_i[3:0];
				trans_ctrl_reg[6:5] <= reg_data_i[6:5];
				trans_ctrl_reg[13:13] <= reg_data_i[13:13];
			end
	end;
	
	assign reg_trans_ctrl_o = {18'd0, trans_ctrl_reg};

	
	
	
	
	
	reg [2:0] status_reg;
	
	always @ (posedge clk_i, negedge reset_n_i)
	begin
		if (!reset_n_i)
		begin
			status_reg <= 0;
		end
		else
		begin
			status_reg[0] <= spi_busy_i;
			status_reg[1] <= rx_empty_i;
			status_reg[2] <= tx_full_i;
		end
	end;
	
	assign reg_status_o = {29'd0, status_reg};
	
endmodule