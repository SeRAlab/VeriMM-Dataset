module mealy_machine_1 (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter X=0, Y=1, Z=2;

    assign next_state[X] = (state[Y] & in) | (state[Z] & ~in);
    assign next_state[Y] = (state[X] & ~in) | (state[Z] & in);
    assign next_state[Z] = (state[X] & in) | (state[Y] & ~in);

    assign out = (state[X] & in) | (state[Y] & ~in);

endmodule