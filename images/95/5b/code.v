module mealy_machine_6 (
  input in,
  input [5:0] state,
  output reg [5:0] next_state,
  output reg out);parameter U=0, V=1, W=2, X=3, Y=4, Z=5;

assign next_state[U] = (state[U] & in) | (state[V] & in) | (state[W] & ~in);
assign next_state[V] = (state[U] & ~in) | (state[X] & in);
assign next_state[W] = (state[U] & in) | (state[Y] & ~in);
assign next_state[X] = (state[V] & ~in) | (state[Y] & in);
assign next_state[Y] = (state[W] & ~in) | (state[Z] & in);
assign next_state[Z] = (state[X] & ~in) | (state[Y] & in);

assign out = (state[U] & in) | state[W] | (state[X] & ~in) | (state[Y] & in & in) | (state[Z] & in | in);

endmodule