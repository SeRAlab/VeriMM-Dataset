module top_module(input [6:0] rx_round,input [31:0] rx_x,input [31:0] rx_y,input [31:0] rx_z,output reg [31:0] tx_f);always @ (*) 
  begin 
  if (rx_round <= 15) 
  tx_f = rx_x ^ rx_y ^ rx_z; 
  else if (rx_round <= 31) 
  tx_f = (rx_x & rx_y) | ((~rx_x) & rx_z); 
  else if (rx_round <= 47) 
  tx_f = (rx_x | (~rx_y)) ^ rx_z; 
  else if (rx_round <= 63) 
  tx_f = (rx_x & rx_z) | (rx_y & (~rx_z)); 
  else 
  tx_f = rx_x ^ (rx_y | (~rx_z)); 
  end 
 endmodule