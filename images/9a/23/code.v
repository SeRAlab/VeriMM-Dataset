module top_module(in0, in1, in2, in3, sel, out);input in0, in1, in2, in3, sel;
  output out;

  wire w1, w2, w3;

  assign w1 = sel ? in3 : in2;
  assign w2 = sel ? in1 : in0;
  assign w3 = sel % 2 ? w1 : w2;

  assign out = sel > 1 ? w3 : w2;
endmodule