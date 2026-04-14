module top_module(
  input in,
  input sel2,
  input sel1,
  input sel0,
  output out0,
  output out1,
  output out2,
  output out3,
  output out4,
  output out5,
  output out6,
  output out7
);assign out0 = (sel2 == 0) && (sel1 == 0) && (sel0 == 0) ? in : 0;
  assign out1 = (sel2 == 0) && (sel1 == 0) && (sel0 == 1) ? in : 0;
  assign out2 = (sel2 == 0) && (sel1 == 1) && (sel0 == 0) ? in : 0;
  assign out3 = (sel2 == 0) && (sel1 == 1) && (sel0 == 1) ? in : 0;
  assign out4 = (sel2 == 1) && (sel1 == 0) && (sel0 == 0) ? in : 0;
  assign out5 = (sel2 == 1) && (sel1 == 0) && (sel0 == 1) ? in : 0;
  assign out6 = (sel2 == 1) && (sel1 == 1) && (sel0 == 0) ? in : 0;
  assign out7 = (sel2 == 1) && (sel1 == 1) && (sel0 == 1) ? in : 0;

endmodule