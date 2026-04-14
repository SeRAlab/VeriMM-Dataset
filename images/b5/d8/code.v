module top_module(input nRESET,input CLK_SERVID,input CLK_6MB,input [6:0] VIDEO_R,input [6:0] VIDEO_G,input [6:0] VIDEO_B,output VIDEO_R_SER,output VIDEO_G_SER,output VIDEO_B_SER,output VIDEO_CLK_SER,output VIDEO_LAT_SER);reg [6:0] R_SR; 
  reg [6:0] G_SR; 
  reg [6:0] B_SR; 
  reg [2:0] BIT_CNT; 
  reg [1:0] VIDEO_LOAD; 
  assign VIDEO_CLK_SER = CLK_SERVID; 
  assign VIDEO_LAT_SER = ~|{BIT_CNT[2:1]}; 
  assign VIDEO_R_SER = R_SR[6]; 
  assign VIDEO_G_SER = G_SR[6]; 
  assign VIDEO_B_SER = B_SR[6]; 
  always @(negedge CLK_SERVID) 
  begin 
  if (!nRESET) 
  begin 
  R_SR <= 7'b0000000; 
  G_SR <= 7'b0000000; 
  B_SR <= 7'b0000000; 
  BIT_CNT <= 3'b000; 
  end 
  else 
  begin 
  VIDEO_LOAD <= {VIDEO_LOAD[0], CLK_6MB}; 
  if (VIDEO_LOAD == 2'b01) 
  begin 
  R_SR <= VIDEO_R; 
  G_SR <= VIDEO_G; 
  B_SR <= VIDEO_B; 
  BIT_CNT <= 3'b000; 
  end 
  else 
  begin 
  R_SR <= {R_SR[5:0], 1'b0}; 
  G_SR <= {G_SR[5:0], 1'b0}; 
  B_SR <= {B_SR[5:0], 1'b0}; 
  BIT_CNT <= BIT_CNT + 1'b1; 
  end 
  end 
  end 
 endmodule