module mealy_machine_2 (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter M=0, N=1, O=2;
    
    assign next_state[M] = (state[N] & ~in) | (state[O] & in);
    assign next_state[N] = (state[M] & ~in) | (state[O] & ~in);
    assign next_state[O] = (state[M] & in) | (state[N] & in);
    
    assign out = (state[M] & in) | state[O];
    
endmodule