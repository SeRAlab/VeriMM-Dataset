module top_module(input wire[31:0] cfg_ar_addr,input wire[2:0] cfg_ar_prot,output wire cfg_ar_ready,input wire cfg_ar_valid,input wire[31:0] cfg_aw_addr,input wire[2:0] cfg_aw_prot,output wire cfg_aw_ready,input wire cfg_aw_valid,input wire cfg_b_ready,output wire[1:0] cfg_b_resp,output wire cfg_b_valid,output wire[63:0] cfg_r_data,input wire cfg_r_ready,output wire[1:0] cfg_r_resp,output wire cfg_r_valid,input wire[63:0] cfg_w_data,output wire cfg_w_ready,input wire[7:0] cfg_w_strb,input wire cfg_w_valid,input wire[63:0] din_data,input wire din_last,output wire din_ready,input wire din_valid,output wire[63:0] dout_data,output wire dout_last,input wire dout_ready,output wire dout_valid,input wire[63:0] headers_data,input wire headers_last,output wire headers_ready,input wire headers_valid,input wire[63:0] patternMatch_data,input wire patternMatch_last,output wire patternMatch_ready,input wire patternMatch_valid);assign cfg_ar_ready = 1'bx; 
  assign cfg_aw_ready = 1'bx; 
  assign cfg_b_resp = 2'bxx; 
  assign cfg_b_valid = 1'bx; 
  assign cfg_r_data = 64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx; 
  assign cfg_r_resp = 2'bxx; 
  assign cfg_r_valid = 1'bx; 
  assign cfg_w_ready = 1'bx; 
  assign din_ready = 1'bx; 
  assign dout_data = 64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx; 
  assign dout_last = 1'bx; 
  assign dout_valid = 1'bx; 
  assign headers_ready = 1'bx; 
  assign patternMatch_ready = 1'bx; 
 endmodule