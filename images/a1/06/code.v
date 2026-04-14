module fsm_4 (
  input X,
  input [3:0] state,
  output reg [3:0] next_state,
  output reg out);parameter I=0, J=1, K=2, L=3;

    assign next_state[I] = (state[I] & ~X) | (state[L] & ~X);
    assign next_state[J] = (state[I] & X) | (state[J] & X);
    assign next_state[K] = (state[J] & ~X) | (state[K] & ~X);
    assign next_state[L] = (state[K] & X) | (state[L] & X);

    assign out = state[J] | state[K];

endmodule