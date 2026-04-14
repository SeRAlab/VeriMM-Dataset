module moore_machine_18 (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output reg out);parameter M=0, N=1, O=2, P=3;

    assign next_state[M] = (state[O] & ~in) | (state[N] & in);
    assign next_state[N] = (state[M] & ~in) | (state[P] & in);
    assign next_state[O] = (state[M] & in) | (state[P] & ~in);
    assign next_state[P] = (state[N] & ~in) | (state[O] & in);
    
    assign out = state[M] | state[O];
    
endmodule