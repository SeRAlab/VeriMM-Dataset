module top_module(
	input clk,
	input reset,

	
	input avs_ctrl_address,
	input avs_ctrl_write,
	input [7:0]avs_ctrl_writedata,
	input avs_ctrl_read,
	output [7:0]avs_ctrl_readdata,

	
	output ready,
	input valid,
	input [15:0]data,
	input startofpacket,
	input endofpacket,
	input empty,
	
	
	output tx_write,
	output [15:0]tx_data,
	output [1:0]tx_mask,
	input  tx_full,

	
	output rx_read,
	input  [15:0]rx_data,
	input  rx_mask,
	input  rx_empty
);wire [7:0]readdata_fifo;
	wire [7:0]status = { 7'b0000000, !rx_empty };
	wire si_request; 

	assign si_request = avs_ctrl_write && avs_ctrl_address && avs_ctrl_writedata[0];
	assign avs_ctrl_readdata = avs_ctrl_read ?
		(avs_ctrl_address ? status : readdata_fifo) : 8'd0;

	
	reg rx_upper;
	assign readdata_fifo = rx_upper ? rx_data[15:8] : rx_data[7:0];
	assign rx_read = avs_ctrl_read && !avs_ctrl_address && !rx_empty && (!rx_mask || rx_upper);
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) rx_upper <= 0;
		else if (avs_ctrl_read && !avs_ctrl_address && !rx_empty)
			rx_upper <= !rx_upper && rx_mask;
	end


	

	assign ready  = !tx_full;
	wire tx_empty = endofpacket && empty;
	wire tx_write_dat = valid && ready;

	reg si; 
	wire si_send = si && ready && !valid;
	always @(posedge clk or posedge reset)
	begin
		if (reset) si <= 0;
		else if (si_send)    si <= 0;
		else if (si_request) si <= 1;
	end

	assign tx_data = {data[7:0], data[15:8]};
	assign tx_mask = si_send ? 2'b00 : {!tx_empty, 1'b1};
	assign tx_write = si_send || tx_write_dat;

endmodule