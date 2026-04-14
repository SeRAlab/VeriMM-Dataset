module top_module(input clk,input rst_n,input i_icb_cmd_valid,output i_icb_cmd_ready,input [32-1:0] i_icb_cmd_addr,input i_icb_cmd_read,input [32-1:0] i_icb_cmd_wdata,output i_icb_rsp_valid,input i_icb_rsp_ready,output [32-1:0] i_icb_rsp_rdata,input f_icb_cmd_valid,output f_icb_cmd_ready,input [32-1:0] f_icb_cmd_addr,input f_icb_cmd_read,input [32-1:0] f_icb_cmd_wdata,output f_icb_rsp_valid,input f_icb_rsp_ready,output [32-1:0] f_icb_rsp_rdata);assign i_icb_cmd_ready = 1'b0; 
  assign i_icb_rsp_valid = 1'b0; 
  assign i_icb_rsp_rdata = 32'b0; 
  assign f_icb_cmd_ready = 1'b0; 
  assign f_icb_rsp_valid = 1'b0; 
  assign f_icb_rsp_rdata = 32'b0; 
 endmodule