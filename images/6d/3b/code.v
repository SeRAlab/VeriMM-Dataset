module top_module(rx_rst,rx_clk,rx_x,rx_y,rx_z,tx_x,tx_y,tx_z);parameter shift=0,para=0;
input rx_rst,rx_clk;
input signed[31:0] rx_x,rx_y;
input signed[11:0] rx_z;
output[31:0] tx_x,tx_y;
output[11:0] tx_z;



(*keep="yes"*) reg[31:0] tx_x,tx_y;
(*keep="yes"*) reg[11:0] tx_z;


always @(posedge rx_clk) begin
	if(rx_rst) begin
		tx_x <= 32'b0;
		tx_y <= 32'b0;
		tx_z <= 12'b0;
	end
	else begin
		if(rx_y[31]^rx_x[31]) begin
			tx_x <= rx_x - (rx_y>>>shift);
			tx_y <= rx_y + (rx_x>>>shift);
			tx_z <= rx_z - para;
		end
		else begin
			tx_x <= rx_x + (rx_y>>>shift);
			tx_y <= rx_y - (rx_x>>>shift);
			tx_z <= rx_z + para;
		end
	end
end


endmodule