module fsm_3 (
  input Y,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg Z);parameter A1=0, B1=1, C1=2;

    assign next_state[A1] = (state[B1] & Y) | (state[C1] & ~Y);
    assign next_state[B1] = (state[A1] & ~Y) | (state[B1] & ~Y);
    assign next_state[C1] = (state[A1] & Y) | (state[C1] & Y);

    assign Z = (state[A1] & Y) | (state[B1] & ~Y) | state[C1];

endmodule