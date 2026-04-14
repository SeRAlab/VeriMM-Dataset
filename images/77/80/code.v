module mealy_machine_20 (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter T=0, U=1, V=2;

    assign next_state[T] = (state[U] & ~in) | (state[V] & in);
    assign next_state[U] = (state[T] & ~in) | (state[V] & in);
    assign next_state[V] = (state[T] & in) | (state[U] & in);

    assign out = (state[T] & in) | (state[U] & ~in) | state[V];

endmodule