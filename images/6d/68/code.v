module top_module(
  input in0,
  input in1,
  input in2,
  input in3,
  input sel0,
  input sel1,
  output out
);assign out = (sel1 == 0 && sel0 == 0) ? in0 :
               (sel1 == 0 && sel0 == 1) ? in1 :
               (sel1 == 1 && sel0 == 0) ? in2 :
               (sel1 == 1 && sel0 == 1) ? in3 :
               1'bx;

endmodule