module moore_machine_17 (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output reg out);parameter I=0, J=1, K=2, L=3;

    assign next_state[I] = (state[K] & ~in) | (state[J] & in);
    assign next_state[J] = (state[I] & ~in) | (state[L] & in);
    assign next_state[K] = (state[I] & in) | (state[L] & ~in);
    assign next_state[L] = (state[J] & ~in) | (state[K] & in);
    
    assign out = state[J] | state[L];
    
endmodule