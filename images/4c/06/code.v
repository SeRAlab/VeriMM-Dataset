module moore_machine_11 (
  input in,
  input [4:0] state,
  output reg [4:0] next_state,
  output reg out);parameter I=0, J=1, K=2, L=3, M=4;

    assign next_state[I] = (state[J] & in) | (state[L] & ~in);
    assign next_state[J] = (state[I] & ~in) | (state[K] & ~in);
    assign next_state[K] = (state[I] & in) | (state[L] & in);
    assign next_state[L] = (state[J] & ~in) | (state[M] & ~in);
    assign next_state[M] = (state[K] & in) | (state[L] & in);
    
    assign out = state[I] | state[K] | state[M];
    
endmodule