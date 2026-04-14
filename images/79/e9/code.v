module moore_machine_6 (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter L=0, M=1, N=2;
    
    assign next_state[L] = (state[L] & ~in) | (state[M] & in);
    assign next_state[M] = (state[L] & in) | (state[N] & ~in);
    assign next_state[N] = (state[M] & ~in) | (state[N] & in);
    
    assign out = state[M];
    
endmodule