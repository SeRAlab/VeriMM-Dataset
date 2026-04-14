module top_module(input clk,input rst_n,input rx_int,output pos_rx_int,output neg_rx_int,output doub_rx_int);reg rx_int0,rx_int1,rx_int2; 
 always @(posedge clk or negedge rst_n) 
  begin 
  if(!rst_n) 
  begin 
  rx_int0 <= 1'b0; 
  rx_int1 <= 1'b0; 
  rx_int2 <= 1'b0; 
  end 
  else 
  begin 
  rx_int0 <= rx_int; 
  rx_int1 <= rx_int0; 
  rx_int2 <= rx_int1; 
  end 
  end 
 assign pos_rx_int = rx_int1 & ~rx_int2; 
 assign neg_rx_int = ~rx_int1 & rx_int2; 
 assign doub_rx_int = rx_int1 ^ rx_int2; 
 endmodule