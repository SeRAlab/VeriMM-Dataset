module moore_machine_12 (
  input in1,
  input in2,
  input [4:0] state,
  output reg [4:0] next_state,
  output reg out);parameter M=0, N=1, O=2, P=3, Q=4;

    assign next_state[M] = (state[N] & in1) | (state[Q] & ~in1);
    assign next_state[N] = (state[M] & ~in1 & ~in2) | (state[O] & in2);
    assign next_state[O] = (state[M] & in1) | (state[P] & in2);
    assign next_state[P] = (state[N] & in1 & in2) | (state[O] & ~in2);
    assign next_state[Q] = (state[M] & in1 & ~in2) | (state[P] & ~in2);

    assign out = state[N] | state[P];

endmodule