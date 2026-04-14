module top_module(input clk,input rst_n,input [3:0] num,input sel_data,input [7:0] rx_data,output reg rs232_tx);always @(posedge clk or negedge rst_n) 
  if(!rst_n) 
  rs232_tx <= 1'b1; 
  else 
  if(sel_data) 
  case(num) 
  0: rs232_tx <= 1'b0; 
  1: rs232_tx <= rx_data[0]; 
  2: rs232_tx <= rx_data[1]; 
  3: rs232_tx <= rx_data[2]; 
  4: rs232_tx <= rx_data[3]; 
  5: rs232_tx <= rx_data[4]; 
  6: rs232_tx <= rx_data[5]; 
  7: rs232_tx <= rx_data[6]; 
  8: rs232_tx <= rx_data[7]; 
  9: rs232_tx <= 1'b1; 
  default: rs232_tx <= 1'b1; 
  endcase 
 endmodule