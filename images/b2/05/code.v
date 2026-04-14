module top_module(clock, resetn,i_settings,i_register_settings,i_datain, i_datain_valid, o_datain_stall,o_dataout, o_dataout_valid, i_dataout_stall);parameter DATA_WIDTH = 32; 
  input clock; 
  input resetn; 
  input i_settings; 
  input [DATA_WIDTH-1:0] i_register_settings; 
  input [DATA_WIDTH-1:0] i_datain; 
  input i_datain_valid; 
  output o_datain_stall; 
  output [DATA_WIDTH-1:0] o_dataout; 
  output o_dataout_valid; 
  input i_dataout_stall; 
  assign o_dataout = i_settings ? i_register_settings : i_datain; 
  assign o_dataout_valid = i_datain_valid; 
  assign o_datain_stall = i_dataout_stall; 
 endmodule