module mealy_machine_12 (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter A=0, B=1, C=2;

    assign next_state[A] = (state[B] & in) | (state[C] & ~in);
    assign next_state[B] = (state[A] & ~in) | (state[C] & in);
    assign next_state[C] = (state[A] & in) | (state[B] & ~in);
    
    assign out = (state[A] & in) | (state[B] & ~in) | state[C];
    
endmodule