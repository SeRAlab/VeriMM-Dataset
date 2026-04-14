module mealy_machine_24 (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter W=0, X=1, Y=2;

    assign next_state[W] = (state[X] & ~in) | (state[Y] & in);
    assign next_state[X] = (state[W] & ~in) | (state[Y] & in);
    assign next_state[Y] = (state[W] & in) | (state[X] & in);

    assign out = (state[W] & ~in) | (state[X] & in) | state[Y];

endmodule