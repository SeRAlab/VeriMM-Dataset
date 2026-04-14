module top_module(input frame_i,output reset_o,output we_o,output ptr_inc_o,input sys_clk_i,input sys_reset_i);reg prev_frame_i; 
  reg curr_frame_i; 
  wire ready = curr_frame_i & ~prev_frame_i; 
  assign we_o = ready; 
  reg reset; 
  assign reset_o = reset; 
  assign ptr_inc_o = reset; 
  always @(posedge sys_clk_i) begin 
  if (sys_reset_i) begin 
  curr_frame_i <= 0; 
  prev_frame_i <= 0; 
  reset <= 0; 
  end else begin 
  curr_frame_i <= frame_i; 
  prev_frame_i <= curr_frame_i; 
  reset <= we_o; 
  end 
  end 
 endmodule