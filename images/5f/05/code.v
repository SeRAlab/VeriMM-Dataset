module top_module( START, MEI, DFLOAT, BWD, SRC1, SRC2,MSD_1, MSD_2, LSD_1, LSD_2, LOAD_MSD, LOAD_LSD1, LOAD_LSD2 );input [1:0] START; 
  input MEI,DFLOAT; 
  input [1:0] BWD; 
  input [31:0] SRC1,SRC2; 
  output [52:32] MSD_1,MSD_2; 
  output [31:0] LSD_1,LSD_2; 
  output LOAD_MSD,LOAD_LSD1,LOAD_LSD2; 
  reg [31:0] LSD_1,LSD_2; 
  assign MSD_1 = MEI ? 21'h0 : {1'b1,SRC1[19:0]}; 
  assign MSD_2 = MEI ? 21'h0 : {1'b1,SRC2[19:0]}; 
  always @(MEI or BWD or SRC1) 
  casex ({MEI,BWD}) 
  3'b100 : LSD_1 = {24'h000000,SRC1[7:0]}; 
  3'b101 : LSD_1 = {16'h0000,SRC1[15:0]}; 
  default : LSD_1 = SRC1; 
  endcase 
  always @(MEI or BWD or SRC2) 
  casex ({MEI,BWD}) 
  3'b100 : LSD_2 = {24'h000000,SRC2[7:0]}; 
  3'b101 : LSD_2 = {16'h0000,SRC2[15:0]}; 
  default : LSD_2 = SRC2; 
  endcase 
  assign LOAD_MSD = (START[0] & MEI) | (START[0] & DFLOAT); 
  assign LOAD_LSD1 = (START[0] & MEI) | (START[1] & DFLOAT); 
  assign LOAD_LSD2 = (START[1] & MEI) | (START[1] & DFLOAT); 
 endmodule