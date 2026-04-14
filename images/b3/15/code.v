module moore_fsm (
  input A,
  input [1:0] state,
  output reg [1:0] next_state,
  output reg out);parameter S1=0, S2=1;

    assign next_state[S1] = (state[S1] & ~A) | (state[S2] & ~A);
    assign next_state[S2] = (state[S1] & A) | (state[S2] & A);

    assign out = state[S2];

endmodule