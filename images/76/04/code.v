module top_module(HARD_ERR,LANE_UP,USER_CLK,CHANNEL_HARD_ERR);`define DLY #1 
  input HARD_ERR; 
  input LANE_UP; 
  input USER_CLK; 
  output CHANNEL_HARD_ERR; 
  reg CHANNEL_HARD_ERR; 
  wire channel_hard_err_c; 
  wire reset_channel_c; 
  assign channel_hard_err_c = |HARD_ERR ; 
  always @(posedge USER_CLK) 
  begin 
  CHANNEL_HARD_ERR <= `DLY channel_hard_err_c; 
  end 
  endmodule