module mealy_machine_2 (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter E=0, F=1, G=2;

    assign next_state[E] = (state[F] & in) | (state[G] & ~in);
    assign next_state[F] = (state[E] & ~in) | (state[G] & in);
    assign next_state[G] = (state[E] & in) | (state[F] & ~in);

    assign out = (state[E]) | (state[F] & ~in) | (state[G] & in);

endmodule