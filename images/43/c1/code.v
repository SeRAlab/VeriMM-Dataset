module fsm_3 (
  input E,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter M=0, N=1, O=2;

    assign next_state[M] = (state[M] & ~E) | (state[O] & E);
    assign next_state[N] = (state[M] & E) | (state[N] & E);
    assign next_state[O] = (state[N] & ~E) | (state[O] & ~E);

    assign out = state[N] | state[O];

endmodule