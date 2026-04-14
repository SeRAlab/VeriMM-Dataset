module top_module(s, leds);input [2:0] s; 
  output reg [0:6] leds; 
  always @(s) 
  case (s) 
  3'b000: leds = 7'b0000001; 
  3'b001: leds = 7'b1001111; 
  3'b010: leds = 7'b0010010; 
  3'b011: leds = 7'b0000110; 
  3'b100: leds = 7'b1001100; 
  3'b101: leds = 7'b0100100; 
  3'b110: leds = 7'b0100000; 
  3'b111: leds = 7'b0001111; 
  default: leds = 7'bx; 
  endcase 
 endmodule