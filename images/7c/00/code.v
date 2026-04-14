module moore_machine_10 (
  input in1,
  input in2,
  input [3:0] state,
  output reg [3:0] next_state,
  output reg out);parameter A=0, B=1, C=2, D=3;

    assign next_state[A] = (state[B] & in1) | (state[D] & in2);
    assign next_state[B] = (state[A] & ~in1 & ~in2) | (state[C] & in2) | (state[D] & in1);
    assign next_state[C] = (state[A] & in1) | (state[B] & in1) | (state[D] & ~in2);
    assign next_state[D] = (state[B] & in2 & ~in1) | (state[C] & ~in2);

    assign out = state[B] | state[C];

endmodule