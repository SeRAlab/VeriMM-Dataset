module top_module(input clock,input reset,input c_pad,input d_pad,input e_pad,input f_pad,input g_pad,output reg reset_sync,output reg c_pad_sync,output reg d_pad_sync,output reg e_pad_sync,output reg f_pad_sync,output reg g_pad_sync,output pad_touched);initial 
  begin 
  reset_sync <= 0; 
  c_pad_sync <= 0; 
  d_pad_sync <= 0; 
  e_pad_sync <= 0; 
  f_pad_sync <= 0; 
  g_pad_sync <= 0; 
  end 
  always @(posedge clock) 
  begin 
  reset_sync <= reset; 
  c_pad_sync <= c_pad; 
  d_pad_sync <= d_pad; 
  e_pad_sync <= e_pad; 
  f_pad_sync <= f_pad; 
  g_pad_sync <= g_pad; 
  end 
  assign pad_touched = c_pad_sync | d_pad_sync | e_pad_sync | f_pad_sync | g_pad_sync; 
 endmodule