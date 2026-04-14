module top_module(i_clk, i_async, o_sync);input i_clk; 
  input i_async; 
  output o_sync; 
  reg samp_rising; 
  reg o_sync; 
  initial begin 
  samp_rising <= 1'b0; 
  o_sync <= 1'b0; 
  end 
  always @( posedge i_clk ) 
  samp_rising <= i_async; 
  always @( negedge i_clk ) 
  o_sync <= samp_rising; 
 endmodule