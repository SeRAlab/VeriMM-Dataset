module mealy_machine_4 (
  input in1,
  input in2,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter R=0, S=1, T=2;

    assign next_state[R] = (state[S] & in1 & ~in2) | (state[T] & ~in2);
    assign next_state[S] = (state[R] & in1 & in2) | (state[T] & in1);
    assign next_state[T] = (state[R] & ~in2) | (state[S] & in1 & ~in2);

    assign out = (state[R]) | (state[S] & in1 & in2) | (state[T] & (~in1 | in2));

endmodule