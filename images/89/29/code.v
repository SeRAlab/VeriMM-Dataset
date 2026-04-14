module mealy_machine_28 (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter D=0, E=1, F=2;

    assign next_state[D] = (state[E] & ~in) | (state[F] & in);
    assign next_state[E] = (state[D] & ~in) | (state[F] & in);
    assign next_state[F] = (state[D] & in) | (state[E] & in);

    assign out = (state[D] & ~in) | state[E] | (state[F] & in);

endmodule