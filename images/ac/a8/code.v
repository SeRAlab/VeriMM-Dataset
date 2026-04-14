module top_module(
  input in0,
  input in1,
  input in2,
  input in3,
  input sel0,
  input sel1,
  output out
);// Selection logic
  wire sel_00 = ~(sel0 | sel1);
  wire sel_01 = ~sel0 & sel1;
  wire sel_10 = sel0 & ~sel1;
  wire sel_11 = sel0 & sel1;

  // Output selection
  assign out = sel_00 ? in0 : sel_01 ? in1 : sel_10 ? in2 : in3;

endmodule