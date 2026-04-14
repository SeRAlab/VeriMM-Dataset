module moore_fsm (
  input C,
  input [1:0] state,
  output reg [1:0] next_state,
  output reg out);parameter S=0, T=1;

    assign next_state[S] = (state[S] & ~C) | (state[T] & ~C);
    assign next_state[T] = (state[S] & C) | (state[T] & C);

    assign out = (state[S] & C) | (state[T] & ~C);

endmodule