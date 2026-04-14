module top_module(clock, resetn, i_settings,i_register_settings,i_dataa, i_dataa_valid, o_dataa_stall,i_datab, i_datab_valid, o_datab_stall,o_dataouta, o_dataouta_valid, i_dataouta_stall,o_dataoutb, o_dataoutb_valid, i_dataoutb_stall);parameter DATA_WIDTH = 32; 
  input clock; 
  input resetn; 
  input [1:0] i_settings; 
  input [DATA_WIDTH-1:0] i_register_settings; 
  input [DATA_WIDTH-1:0] i_dataa, i_datab; 
  input i_dataa_valid, i_datab_valid; 
  output o_dataa_stall, o_datab_stall; 
  output [DATA_WIDTH-1:0] o_dataouta, o_dataoutb; 
  output o_dataouta_valid, o_dataoutb_valid; 
  input i_dataouta_stall, i_dataoutb_stall; 
  assign o_dataouta = i_settings[0] ? i_register_settings : i_dataa; 
  assign o_dataoutb = i_settings[1] ? i_register_settings : i_datab; 
  assign o_dataouta_valid = i_dataa_valid; 
  assign o_dataoutb_valid = i_datab_valid; 
  assign o_dataa_stall = i_dataouta_stall; 
  assign o_datab_stall = i_dataoutb_stall; 
 endmodule