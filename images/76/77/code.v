module fsm_4 (
  input F,
  input [3:0] state,
  output reg [3:0] next_state,
  output reg out);parameter X1=0, Y1=1, Z1=2, W1=3;

    assign next_state[X1] = (state[W1] & ~F) | (state[Z1] & ~F);
    assign next_state[Y1] = (state[X1] & F) | (state[Y1] & F);
    assign next_state[Z1] = (state[X1] & ~F) | (state[Y1] & ~F);
    assign next_state[W1] = (state[Z1] & F) | (state[W1] & F);

    assign out = (state[X1] & ~F) | (state[Y1] & F) | (state[Z1] & 1) | (state[W1] & 0);

endmodule