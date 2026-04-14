module top_module(input clk,output [7:0] led_out);parameter LEDS_INIT = 10'b1100000000; 
  parameter DIR_INIT = 1; 
  reg [9:0] leds = LEDS_INIT; 
  reg [3:0] position = DIR_INIT*8; 
  reg direction = DIR_INIT; 
  always @ (posedge clk) begin 
  if (direction == 0) begin 
  leds <= leds << 1; 
  end else begin 
  leds <= leds >> 1; 
  end 
  position <= position + 1; 
  end 
  always @ (position) begin 
  if (position < 8) begin 
  direction = 0; 
  end else begin 
  direction = 1; 
  end 
  end 
  assign led_out = leds[8:1]; 
 endmodule