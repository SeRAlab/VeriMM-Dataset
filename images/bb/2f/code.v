module moore_machine_19 (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output reg out);parameter T=0, U=1, V=2, W=3;

    assign next_state[T] = (state[V] & ~in) | (state[U] & in);
    assign next_state[U] = (state[T] & ~in) | (state[W] & in);
    assign next_state[V] = (state[T] & in) | (state[W] & ~in);
    assign next_state[W] = (state[U] & ~in) | (state[V] & in);
    
    assign out = state[U] | state[W];
    
endmodule