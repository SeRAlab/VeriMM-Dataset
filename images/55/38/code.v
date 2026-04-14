module top_module(clock, reset,ce_16, baud_freq, baud_limit);input clock; 
 input reset; 
 output ce_16; 
 input [11:0] baud_freq; 
 input [15:0] baud_limit; 
 reg ce_16; 
 reg [15:0] counter; 
 always @ (posedge clock or posedge reset) 
 begin 
  if (reset) 
  counter <= 16'b0; 
  else if (counter >= baud_limit) 
  counter <= counter - baud_limit; 
  else 
  counter <= counter + baud_freq; 
 end 
 always @ (posedge clock or posedge reset) 
 begin 
  if (reset) 
  ce_16 <= 1'b0; 
  else if (counter >= baud_limit) 
  ce_16 <= 1'b1; 
  else 
  ce_16 <= 1'b0; 
 end 
 endmodule