module top_module(
  input a,
  input b,
  output q
);assign q = (a) ? (~b) : (b);

endmodule