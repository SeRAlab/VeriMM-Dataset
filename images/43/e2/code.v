module top_module(BWD, FLOAT, SRC1, SRC2, DEST1, DEST2);input [1:0] BWD; 
  input FLOAT; 
  input [31:0] SRC1,SRC2; 
  output [31:0] DEST1,DEST2; 
  wire sign1,sign2; 
  reg [31:0] DEST1,DEST2; 
  assign sign1 = BWD[0] ? SRC1[15] : SRC1[7]; 
  always @(FLOAT or BWD or SRC1 or sign1) 
  casex ({FLOAT,BWD,sign1}) 
  4'b0_00_0 : DEST1 = {24'h000000, SRC1[7:0]}; 
  4'b0_00_1 : DEST1 = {24'hFFFFFF, SRC1[7:0]}; 
  4'b0_01_0 : DEST1 = { 16'h0000,SRC1[15:0]}; 
  4'b0_01_1 : DEST1 = { 16'hFFFF,SRC1[15:0]}; 
  4'b1_xx_x : DEST1 = { 9'h001,SRC1[22:0]}; 
  default : DEST1 = SRC1; 
  endcase 
  assign sign2 = BWD[0] ? SRC2[15] : SRC2[7]; 
  always @(FLOAT or BWD or SRC2 or sign2) 
  casex ({FLOAT,BWD,sign2}) 
  4'b0_00_0 : DEST2 = {24'h000000, SRC2[7:0]}; 
  4'b0_00_1 : DEST2 = {24'hFFFFFF, SRC2[7:0]}; 
  4'b0_01_0 : DEST2 = { 16'h0000,SRC2[15:0]}; 
  4'b0_01_1 : DEST2 = { 16'hFFFF,SRC2[15:0]}; 
  4'b1_xx_x : DEST2 = { 9'h001,SRC2[22:0]}; 
  default : DEST2 = SRC2; 
  endcase 
 endmodule