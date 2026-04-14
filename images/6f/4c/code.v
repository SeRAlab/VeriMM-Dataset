module top_module(input [3:0] rx_a,input [3:0] rx_b,input rx_c,output [3:0] tx_s,output tx_c);wire [4:0] s = rx_a + rx_b + rx_c; 
  wire [4:0] s_wrap = s + 5'd6; 
  assign tx_s = (s > 5'd9) ? s_wrap[3:0] : s[3:0]; 
  assign tx_c = s > 5'd9; 
 endmodule