module top_module(s_axi_tx_tlast,s_axi_tx_tdata,s_axi_tx_tvalid,s_axi_tx_tready,TX_PE_DATA_V,TX_PE_DATA,CHANNEL_UP,USER_CLK);`define DLY #1 
  input [0:63] s_axi_tx_tdata; 
  input s_axi_tx_tready; 
  input s_axi_tx_tvalid; 
  input s_axi_tx_tlast; 
  output TX_PE_DATA_V; 
  output [0:63] TX_PE_DATA; 
  input CHANNEL_UP; 
  input USER_CLK; 
  reg [0:63] TX_PE_DATA; 
  reg TX_PE_DATA_V; 
  reg in_frame_r; 
  wire in_frame_c; 
  wire ll_valid_c; 
  wire [0:63] tx_pe_data_c; 
  assign ll_valid_c = s_axi_tx_tvalid & s_axi_tx_tready; 
  always @(posedge USER_CLK) 
  if(!CHANNEL_UP) 
  in_frame_r <= `DLY 1'b0; 
  else if(ll_valid_c) 
  begin 
  if(s_axi_tx_tvalid && !s_axi_tx_tlast ) 
  in_frame_r <= `DLY 1'b1; 
  else if(s_axi_tx_tlast) 
  in_frame_r <= `DLY 1'b0; 
  end 
  assign in_frame_c = ll_valid_c & (in_frame_r | s_axi_tx_tvalid); 
  assign tx_pe_data_c = s_axi_tx_tdata; 
  always @(posedge USER_CLK) 
  begin 
  TX_PE_DATA <= `DLY tx_pe_data_c; 
  TX_PE_DATA_V <= `DLY in_frame_c; 
  end 
  endmodule