module mealy_machine_4 (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output reg out);parameter A=0, B=1, C=2, D=3;

    assign next_state[A] = (state[A] & in) | (state[B] & in) | (state[C] & ~in);
    assign next_state[B] = (state[A] & ~in) | (state[D] & in);
    assign next_state[C] = (state[A] & in) | (state[D] & ~in);
    assign next_state[D] = (state[B] & ~in) | (state[C] & in);

    assign out = (state[A] & in) | state[C] | (state[D] & ~in);
    
endmodule