module moore_machine_13 (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output reg out);parameter E=0, F=1, G=2, H=3;

    assign next_state[E] = (state[F] & ~in) | (state[G] & ~in) | (state[H] & in);
    assign next_state[F] = (state[E] & ~in) | (state[H] & in);
    assign next_state[G] = (state[E] & in) | (state[F] & in);
    assign next_state[H] = (state[E] & in) | (state[G] & in);
    
    assign out = state[F] | state[H];
    
endmodule