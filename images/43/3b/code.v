module top_module(
  input I0,
  input I1,
  input [1:0] S,
  output O
);assign O = S[0] ? I1 : I0; // Simple 2-to-1 multiplexer logic
endmodule