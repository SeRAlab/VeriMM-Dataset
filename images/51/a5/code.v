module mealy_machine_1 (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter J=0, K=1, L=2;

    assign next_state[J] = (state[K] & ~in) | (state[L] & ~in);
    assign next_state[K] = (state[J] & in) | (state[L] & in);
    assign next_state[L] = (state[J] & ~in) | (state[K] & in);

    assign out = state[J] | state[K];
    
endmodule