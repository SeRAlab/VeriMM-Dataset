module moore_machine_13 (
  input in,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter H=0, I=1, J=2;

    assign next_state[H] = (state[I] & in) | (state[J] & ~in);
    assign next_state[I] = (state[H] & ~in) | (state[J] & in);
    assign next_state[J] = (state[H] & in) | (state[I] & ~in);

    assign out = state[I] | state[J];

endmodule