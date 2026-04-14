module top_module(input CLK,input [15:0] featurebits,input [23:0] SNES_ADDR,input [7:0] SNES_PA,input SNES_ROMSEL,output [23:0] ROM_ADDR,output ROM_HIT,output IS_SAVERAM,output IS_ROM,output IS_WRITABLE,output msu_enable,output sgb_enable,output r213f_enable,output r2100_hit,output snescmd_enable,output button_enable,output button_addr);parameter [2:0] 
  FEAT_DSPX = 0, 
  FEAT_ST0010 = 1, 
  FEAT_SRTC = 2, 
  FEAT_MSU1 = 3, 
  FEAT_213F = 4, 
 FEAT_2100 = 6; 
 wire [23:0] SRAM_SNES_ADDR; 
 assign IS_ROM = ~SNES_ROMSEL; 
 assign IS_SAVERAM = 0; 
 assign IS_WRITABLE = IS_SAVERAM; 
 assign SRAM_SNES_ADDR = {5'h00, SNES_ADDR[19:16], SNES_ADDR[14:0]}; 
 assign ROM_ADDR = SRAM_SNES_ADDR; 
 assign ROM_HIT = IS_ROM | IS_WRITABLE; 
 assign msu_enable = featurebits[FEAT_MSU1] & (!SNES_ADDR[22] && ((SNES_ADDR[15:0] & 16'hfff8) == 16'h2000)); 
 assign sgb_enable = !SNES_ADDR[22] && ((SNES_ADDR[15:0] & 16'hf808) == 16'h6000 || (SNES_ADDR[15:0] & 16'hf80F) == 16'h600F || (SNES_ADDR[15:0] & 16'hf000) == 16'h7000); 
 assign r213f_enable = featurebits[FEAT_213F] & (SNES_PA == 8'h3f); 
 assign r2100_hit = (SNES_PA == 8'h00); 
 assign snescmd_enable = ({SNES_ADDR[22], SNES_ADDR[15:9]} == 8'b0_0010101); 
 assign button_enable = {SNES_ADDR[23:2],2'b00} == {24'h010F10} && SNES_ADDR[1] != SNES_ADDR[0]; 
 assign button_addr = ~SNES_ADDR[0]; 
 endmodule