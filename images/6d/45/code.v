module traffic_light_controller (
  input clk, 
  input [2:0] state, 
  output reg [2:0] next_state, 
  output reg red, 
  output reg yellow, 
  output reg green);parameter RED=0, GREEN=1, YELLOW=2;

    assign next_state[RED] = state[YELLOW];
    assign next_state[GREEN] = state[RED];
    assign next_state[YELLOW] = state[GREEN];

    assign red = state[RED];
    assign yellow = state[YELLOW];
    assign green = state[GREEN];
    
endmodule