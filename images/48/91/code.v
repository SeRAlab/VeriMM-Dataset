module mealy_fsm_4 (
  input in1,
  input in2,
  input [3:0] state,
  output reg [3:0] next_state,
  output reg out);parameter P=0, Q=1, R=2, S=3;

    assign next_state[P] = (state[R] & in1) | (state[S] & ~in2);
    assign next_state[Q] = (state[P] & in1) | (state[S] & in2);
    assign next_state[R] = (state[P] & ~in1) | (state[Q] & in2);
    assign next_state[S] = (state[Q] & ~in2) | (state[R] & ~in1);

    assign out = (state[P] & (in1 & in2)) | (state[Q] & (in1 | in2)) | (state[R] & ~in1) | (state[S] & ~in2);

endmodule