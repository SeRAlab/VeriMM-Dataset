module top_module(input clk,input srst,output reg [ 3:0] o_tl_cfg_add,output reg [31:0] o_tl_cfg_ctl,output reg o_tl_cfg_ctl_wr,output reg [52:0] o_tl_cfg_sts,output reg o_tl_cfg_sts_wr,input [ 3:0] i_tl_cfg_add,input [31:0] i_tl_cfg_ctl,input i_tl_cfg_ctl_wr,input [52:0] i_tl_cfg_sts,input i_tl_cfg_sts_wr);reg sts_wr_r,sts_wr_rr; 
  reg ctl_wr_r,ctl_wr_rr; 
  always @ (posedge clk) 
  begin 
  if (srst) 
  begin 
  o_tl_cfg_add <= 4'h0; 
  o_tl_cfg_ctl <= {32{1'b0}}; 
  o_tl_cfg_ctl_wr <= {1{1'b0}}; 
  o_tl_cfg_sts <= {53{1'b0}}; 
  o_tl_cfg_sts_wr <= {1{1'b0}}; 
  end 
  else 
  begin 
  sts_wr_r <= i_tl_cfg_sts_wr; 
  sts_wr_rr <= sts_wr_r; 
  o_tl_cfg_sts_wr <= sts_wr_rr; 
  if (o_tl_cfg_sts_wr != sts_wr_rr) 
  o_tl_cfg_sts <= i_tl_cfg_sts; 
  ctl_wr_r <= i_tl_cfg_ctl_wr; 
  ctl_wr_rr <= ctl_wr_r; 
  o_tl_cfg_ctl_wr <= ctl_wr_rr; 
  if (o_tl_cfg_ctl_wr != ctl_wr_rr) 
  begin 
  o_tl_cfg_add <= i_tl_cfg_add; 
  o_tl_cfg_ctl <= i_tl_cfg_ctl; 
  end 
  end 
  end 
 endmodule