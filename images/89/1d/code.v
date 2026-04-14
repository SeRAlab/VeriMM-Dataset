module top_module(
  q,
  i0,
  i1,
  i2,
  i3,
  sel
);output q;
  input i0;
  input i1;
  input i2;
  input i3;
  input [1:0] sel;

  wire w0, w1, w2, w3;

  assign w0 = sel[0] & sel[1] ? i3 : i2;
  assign w1 = sel[0] & sel[1] ? i2 : i1;
  assign w2 = sel[0] & sel[1] ? i1 : i0;
  assign w3 = sel[0] & sel[1] ? i0 : i3;

  assign q = sel[0] & sel[1] ? w0 : sel[0] & ~sel[1] ? w1 : ~sel[0] & sel[1] ? w2 : w3;

endmodule