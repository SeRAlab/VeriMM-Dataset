module top_module(input [3:0] number,output [7:0] result);assign result = (number == 4'd0) ? 8'b00000011: 
  (number == 4'd1) ? 8'b10011111: 
  (number == 4'd2) ? 8'b00100101: 
  (number == 4'd3) ? 8'b00001101: 
  (number == 4'd4) ? 8'b10011001: 
  (number == 4'd5) ? 8'b01001001: 
  (number == 4'd6) ? 8'b01000001: 
  (number == 4'd7) ? 8'b00011111: 
  (number == 4'd8) ? 8'b00000001: 
  (number == 4'd9) ? 8'b00001001: 
  (number == 4'd10) ? 8'b00010001: 
  (number == 4'd11) ? 8'b00000000: 
  (number == 4'd12) ? 8'b01100011: 
  (number == 4'd13) ? 8'b00000010: 
  (number == 4'd14) ? 8'b01100001: 
  8'b01110001; 
 endmodule