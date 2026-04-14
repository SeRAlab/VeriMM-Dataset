module moore_machine_9 (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter U=0, V=1, W=2;

    assign next_state[U] = (state[U] & ~in) | (state[W] & ~in);
    assign next_state[V] = (state[U] & in) | (state[W] & in);
    assign next_state[W] = (state[V] & in) | (state[U] & in);
    
    assign out = state[V];
    
endmodule