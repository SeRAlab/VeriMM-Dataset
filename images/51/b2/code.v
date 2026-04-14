module fsm_3 (
  input A,
  input B,
  input [2:0] state,
  output reg [2:0] next_state,
  output reg out);parameter U=0, V=1, W=2;

    assign next_state[U] = (state[W] & A) | (state[V] & ~B);
    assign next_state[V] = (state[U] & A) | (state[W] & ~A);
    assign next_state[W] = (state[U] & ~A) | (state[V] & B);

    assign out = (state[U] & (A ^ B)) | (state[V] & (A & B)) | (state[W] & (A | B));

endmodule