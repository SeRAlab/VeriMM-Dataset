module top_module(
  input a, b, c,
  output Q );assign Q = b & (a | c);endmodule