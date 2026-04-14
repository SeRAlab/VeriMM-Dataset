module top_module(out, in0, in1, in2, in3, sel0, sel1);output out;
  input in0, in1, in2, in3, sel0, sel1;

  wire w1, w2, w3, w4, w5, w6, w7;

  not #(1) n1 (w1, sel0);
  not #(1) n2 (w2, sel1);

  and #(1) a1 (w3, in0, w1, w2);
  and #(1) a2 (w4, in1, w1, sel1);
  and #(1) a3 (w5, in2, sel0, w2);
  and #(1) a4 (w6, in3, sel0, sel1);

  or #(1) o1 (out, w3, w4, w5, w6);
endmodule