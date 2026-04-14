module top_module(input valid_in,input [32-1:0] data_in,input last_in,input [1-1:0] reset_in,input [1-1:0] set_strb_in,input [8-1:0] set_addr_in,input [1-1:0] ready_out);wire ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net; 
  wire [32-1:0] concat_y_net; 
  wire axi_fifo_m_axis_tlast_net; 
  wire [1-1:0] logical_y_net; 
  wire [1-1:0] set_stb_in_net; 
  wire [8-1:0] set_addr_in_net; 
  wire [1-1:0] ready_out_net; 
  assign ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net = valid_in; 
  assign concat_y_net = data_in; 
  assign axi_fifo_m_axis_tlast_net = last_in; 
  assign logical_y_net = reset_in; 
  assign set_stb_in_net = set_strb_in; 
  assign set_addr_in_net = set_addr_in; 
  assign ready_out_net = ready_out; 
 endmodule