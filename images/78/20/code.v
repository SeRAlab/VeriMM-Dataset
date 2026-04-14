module moore_machine_7 (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter V=0, W=1, X=2;
    
    assign next_state[V] = (state[W] & ~in) | (state[X] & in);
    assign next_state[W] = (state[V] & ~in) | (state[X] & ~in);
    assign next_state[X] = (state[V] & in) | (state[W] & in);
    
    assign out = state[V] | state[X];
    
endmodule