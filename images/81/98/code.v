module mealy_machine_3 (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter S0=0, S1=1, S2=2;

assign next_state[S0] = (state[S0] & in) | (state[S1] & in) | (state[S2] & ~in);
assign next_state[S1] = (state[S0] & ~in) | (state[S2] & in);
assign next_state[S2] = (state[S0] & in) | (state[S1] & ~in);

assign out = (state[S0] & in) | state[S2] | (state[S1] & ~in);

endmodule