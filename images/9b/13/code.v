module digital_lock (
  input clk, 
  input reset, 
  input key1, 
  input key2, 
  input [3:0] state, 
  output reg [3:0] next_state, 
  output reg unlocked);parameter LOCKED=0, UNLOCKED=1, INPUT1=2, INPUT2=3;

    assign next_state[LOCKED] = state[UNLOCKED] | (state[LOCKED] & ~key1);
    assign next_state[INPUT1] = state[LOCKED] & key1;
    assign next_state[INPUT2] = state[INPUT1] & key2;
    assign next_state[UNLOCKED] = state[INPUT2];

    assign unlocked = state[UNLOCKED];
    
endmodule