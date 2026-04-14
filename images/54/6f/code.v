module top_module(
  input a,
  input b,
  input c,
  input d,
  output reg out
);assign out = (a & b & c & d);

endmodule