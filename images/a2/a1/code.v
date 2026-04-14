module washing_machine_controller (
  input clk, 
  input start, 
  input [3:0] state, 
  output reg [3:0] next_state, 
  output reg washing, 
  output reg rinsing, 
  output reg spinning);parameter OFF=0, WASH=1, RINSE=2, SPIN=3;

    assign next_state[OFF] = state[SPIN] | (state[OFF] & ~start);
    assign next_state[WASH] = state[OFF] & start;
    assign next_state[RINSE] = state[WASH];
    assign next_state[SPIN] = state[RINSE];

    assign washing = state[WASH];
    assign rinsing = state[RINSE];
    assign spinning = state[SPIN];
    
endmodule