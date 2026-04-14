module top_module(input wire ACLK,input wire ARESETN,input wire [32:0] S_AXIS_DAT_TDATA,input wire S_AXIS_DAT_TVALID,input wire [3:0] S_AXIS_DAT_TSTRB,input wire [127:0] S_AXIS_DAT_TUSER,input wire S_AXIS_DAT_TLAST,output wire S_AXIS_DAT_TREADY,output wire [32:0] M_AXIS_DAT_TDATA,output wire M_AXIS_DAT_TVALID,output wire [3:0] M_AXIS_DAT_TSTRB,output wire [127:0] M_AXIS_DAT_TUSER,output wire M_AXIS_DAT_TLAST,input wire M_AXIS_DAT_TREADY);assign M_AXIS_DAT_TDATA = S_AXIS_DAT_TDATA; 
  assign M_AXIS_DAT_TVALID = S_AXIS_DAT_TVALID; 
  assign M_AXIS_DAT_TSTRB = S_AXIS_DAT_TSTRB; 
  assign M_AXIS_DAT_TUSER = {S_AXIS_DAT_TUSER[127:32], S_AXIS_DAT_TUSER[23:16], S_AXIS_DAT_TUSER[31:24], S_AXIS_DAT_TUSER[15:0]}; 
  assign M_AXIS_DAT_TLAST = S_AXIS_DAT_TLAST; 
  assign S_AXIS_DAT_TREADY = M_AXIS_DAT_TREADY; 
 endmodule