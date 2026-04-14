module mealy_machine_3 (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output reg out);parameter K=0, L=1, M=2, N=3;

    assign next_state[K] = (state[L] & in) | (state[N] & ~in);
    assign next_state[L] = (state[K] & ~in) | (state[M] & ~in);
    assign next_state[M] = (state[K] & in) | (state[L] & ~in);
    assign next_state[N] = (state[L] & in) | (state[M] & in);

    assign out = (state[L] & in) | (state[M]) | (state[N] & ~in);

endmodule