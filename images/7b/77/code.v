module top_module(input clk,input rst_n,input rs232_rx,input [3:0] num,input sel_data,output rx_en,output reg tx_en,output reg [7:0] rx_data);reg in_1,in_2; 
 always @(posedge clk or negedge rst_n) 
  if(!rst_n) 
  begin 
  in_1 <= 1'b1; 
  in_2 <= 1'b1; 
  end 
  else 
  begin 
  in_1 <= rs232_rx; 
  in_2 <= in_1; 
  end 
 assign rx_en = in_2 & (~in_1); 
  reg [7:0] rx_data_r; 
 always @(posedge clk or negedge rst_n) 
  if(!rst_n) 
  begin 
  rx_data_r <= 8'd0; 
  rx_data <= 8'd0; 
  end 
  else 
  if(sel_data) 
  case(num) 
  0: ; 
  1: rx_data_r[0] <= rs232_rx; 
  2: rx_data_r[1] <= rs232_rx; 
  3: rx_data_r[2] <= rs232_rx; 
  4: rx_data_r[3] <= rs232_rx; 
  5: rx_data_r[4] <= rs232_rx; 
  6: rx_data_r[5] <= rs232_rx; 
  7: rx_data_r[6] <= rs232_rx; 
  8: rx_data_r[7] <= rs232_rx; 
  9: rx_data <= rx_data_r; 
  default: ; 
  endcase 
 always @(posedge clk or negedge rst_n) 
  if(!rst_n) 
  tx_en <= 0; 
  else 
  if(num == 4'd9 && sel_data) 
  tx_en <= 1; 
  else 
  tx_en <= 0; 
 endmodule