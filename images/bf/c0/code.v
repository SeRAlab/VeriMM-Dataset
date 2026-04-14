module usbf_sie_ep
(
     input           clk_i
    ,input           rst_i
    ,input           rx_setup_i
    ,input           rx_valid_i
    ,input           rx_strb_i
    ,input  [  7:0]  rx_data_i
    ,input           rx_last_i
    ,input           rx_crc_err_i
    ,input           rx_full_i
    ,input           rx_ack_i
    ,input  [  7:0]  tx_data_i
    ,input           tx_empty_i
    ,input           tx_flush_i
    ,input  [ 10:0]  tx_length_i
    ,input           tx_start_i
    ,input           tx_data_accept_i
    ,output          rx_space_o
    ,output          rx_push_o
    ,output [  7:0]  rx_data_o
    ,output [ 10:0]  rx_length_o
    ,output          rx_ready_o
    ,output          rx_err_o
    ,output          rx_setup_o
    ,output          tx_pop_o
    ,output          tx_busy_o
    ,output          tx_err_o
    ,output          tx_ready_o
    ,output          tx_data_valid_o
    ,output          tx_data_strb_o
    ,output [  7:0]  tx_data_o
    ,output          tx_data_last_o
);
reg        rx_ready_q;
reg        rx_err_q;
reg [10:0] rx_len_q;
reg        rx_setup_q;
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    rx_ready_q <= 1'b0;
else if (rx_ack_i)
    rx_ready_q <= 1'b0;
else if (rx_valid_i && rx_last_i)
    rx_ready_q <= 1'b1;
assign rx_space_o = !rx_ready_q;
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    rx_len_q <= 11'b0;
else if (rx_ack_i)
    rx_len_q <= 11'b0;
else if (rx_valid_i && rx_strb_i)
    rx_len_q <= rx_len_q + 11'd1;
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    rx_err_q <= 1'b0;
else if (rx_ack_i)
    rx_err_q <= 1'b0;
else if (rx_valid_i && rx_last_i && rx_crc_err_i)
    rx_err_q <= 1'b1;
else if (rx_full_i && rx_push_o)
    rx_err_q <= 1'b1;
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    rx_setup_q <= 1'b0;
else if (rx_ack_i)
    rx_setup_q <= 1'b0;
else if (rx_setup_i)
    rx_setup_q <= 1'b1;
assign rx_length_o = rx_len_q;
assign rx_ready_o  = rx_ready_q;
assign rx_err_o    = rx_err_q;
assign rx_setup_o  = rx_setup_q;
assign rx_push_o   = rx_valid_i & rx_strb_i;
assign rx_data_o   = rx_data_i;
reg        tx_active_q;
reg        tx_err_q;
reg        tx_zlp_q;
reg [10:0] tx_len_q;
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    tx_active_q <= 1'b0;
else if (tx_flush_i)
    tx_active_q <= 1'b0;
else if (tx_start_i)
    tx_active_q <= 1'b1;
else if (tx_data_valid_o && tx_data_last_o && tx_data_accept_i)
    tx_active_q <= 1'b0;
assign tx_ready_o = tx_active_q;
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    tx_zlp_q <= 1'b0;
else if (tx_flush_i)
    tx_zlp_q <= 1'b0;
else if (tx_start_i)
    tx_zlp_q <= (tx_length_i == 11'b0);
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    tx_len_q <= 11'b0;
else if (tx_flush_i)
    tx_len_q <= 11'b0;
else if (tx_start_i)
    tx_len_q <= tx_length_i;
else if (tx_data_valid_o && tx_data_accept_i && !tx_zlp_q)
    tx_len_q <= tx_len_q - 11'd1;
assign tx_data_valid_o = tx_active_q;
assign tx_data_strb_o  = !tx_zlp_q;
assign tx_data_last_o  = tx_zlp_q || (tx_len_q == 11'd1);
assign tx_data_o       = tx_data_i;
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    tx_err_q <= 1'b0;
else if (tx_flush_i)
    tx_err_q <= 1'b0;
else if (tx_start_i)
    tx_err_q <= 1'b0;
else if (!tx_zlp_q && tx_empty_i && tx_data_valid_o)
    tx_err_q <= 1'b1;
assign tx_err_o      = tx_err_q;
assign tx_busy_o     = tx_active_q;
assign tx_pop_o      = tx_data_accept_i & tx_active_q;
endmodule