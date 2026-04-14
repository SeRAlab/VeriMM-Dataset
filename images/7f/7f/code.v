module mealy_machine_2 (
  input in,
  input [1:0] state,
  output reg [1:0] next_state,
  output reg out);parameter P=0, Q=1;

assign next_state[P] = (state[P] & in) | (state[Q] & ~in);
assign next_state[Q] = (state[P] & ~in) | (state[Q] & in);

assign out = (state[P] & in) | (state[Q] & ~in);

endmodule