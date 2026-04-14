module top_module(
  input a,
  input b,
  input op,
  output out
);assign out = op ? ~a : (a ^ b);

endmodule