module top_module(input clk,input [7:0] address,output reg [7:0] note);always @(posedge clk) 
  case(address) 
  0, 1: note <= 8'd27; 
  2: note <= 8'd29; 
  3: note <= 8'd27; 
  4: note <= 8'd32; 
  5: note <= 8'd31; 
  6: note <= 8'd0; 
  7, 8: note <= 8'd27; 
  9: note <= 8'd29; 
  10: note <= 8'd27; 
  11: note <= 8'd34; 
  12: note <= 8'd32; 
  13: note <= 8'd0; 
  14, 15: note <= 8'd27; 
  16: note <= 8'd39; 
  17: note <= 8'd24; 
  18: note <= 8'd32; 
  19: note <= 8'd31; 
  20: note <= 8'd29; 
  21: note <= 8'd0; 
  22, 23: note <= 8'd39; 
  24: note <= 8'd24; 
  25: note <= 8'd32; 
  26: note <= 8'd34; 
  27: note <= 8'd32; 
  default: note <= 8'd0; 
  endcase 
 endmodule