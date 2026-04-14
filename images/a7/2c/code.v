module top_module(mantissa, count);input [9:0] mantissa; 
  output [3:0] count; 
  assign count[3] = ~|mantissa[9:2]; 
  assign count[2] = |mantissa[9:2] & ~|mantissa[9:6]; 
  assign count[1] = count[3] & ~|mantissa[1:0] | ~count[3] & (~count[2] & ~|mantissa[9:8] | count[2] & ~|mantissa[5:4]); 
  assign count[0] = (mantissa[9:8] == 2'b01) | 
  (mantissa[9:6] == 4'b0001) | 
  (mantissa[9:4] == 6'b000001) | 
  (mantissa[9:2] == 8'b00000001) | 
  (mantissa == 10'b0000000001); 
  endmodule