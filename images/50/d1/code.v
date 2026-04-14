module mealy_machine_5 (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output reg out);parameter P=0, Q=1, R=2, S=3;

    assign next_state[P] = (state[R] & ~in) | (state[Q] & in);
    assign next_state[Q] = (state[P] & ~in) | (state[S] & in);
    assign next_state[R] = (state[P] & in) | (state[S] & ~in);
    assign next_state[S] = (state[Q] & ~in) | (state[R] & in);

    assign out = (state[P] & ~in) | state[Q] | (state[S] & in);
    
endmodule