module top_module(
  input a,
  input b,
  input c,
  input d,
  input e,
  input f,
  input g,
  input h,
  output out
);wire and_out;
  wire or_out;
  
  and and_gate(b, c, and_out);
  or or_gate(d, e, f, g, h, or_out);
  
  assign out = a ? and_out : or_out;

endmodule