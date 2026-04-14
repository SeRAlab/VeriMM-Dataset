module top_module(input de_clk,input hb_clk,input prst,input cr_pulse,input [1:0] ps_sel_2,input bc_co,input [31:0] mf_sorg_2,input [31:0] mf_dorg_2,input [1:0] apat_1,input sd_selector,output reg prst_1,output hb_ca_rdy,output de_ca_rdy,output ps16s_2,output ps565s_2,output [31:0] de_sorg_2,output [31:0] de_dorg_2,output [27:0] sorg_2,output [27:0] dorg_2,output or_apat_1);assign or_apat_1 = |apat_1; 
  always @(posedge de_clk) prst_1 <= prst; 
  assign ps16s_2 = ~ps_sel_2[1] & ps_sel_2[0]; 
  assign ps565s_2 = &ps_sel_2[1:0]; 
  assign hb_ca_rdy = 1'b1; 
  assign de_ca_rdy = 1'b1; 
  assign de_sorg_2 = {32{sd_selector}} & mf_sorg_2; 
  assign de_dorg_2 = {32{sd_selector}} & mf_dorg_2; 
  assign sorg_2 = {28{~sd_selector}} & {6'h0, mf_sorg_2[25:4]}; 
  assign dorg_2 = {28{~sd_selector}} & {6'h0, mf_dorg_2[25:4]}; 
 endmodule