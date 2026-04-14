module moore_machine (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output reg out);parameter S=0, T=1, U=2, V=3;
    
    assign next_state[S] = (state[T] & ~in) | (state[V] & ~in);
    assign next_state[T] = (state[S] & ~in) | (state[U] & ~in);
    assign next_state[U] = state[S] & in;
    assign next_state[V] = (state[T] & in) | (state[U] & in);
    
    assign out = state[S] | state[V];
    
endmodule