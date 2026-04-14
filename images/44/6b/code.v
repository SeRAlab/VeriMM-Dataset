module top_module(
  input [3:0] in1,
  input [3:0] in2,
  output eq,
  output gt,
  output lt
);assign eq = (in1 == in2);
  assign gt = (in1 > in2);
  assign lt = (in1 < in2);

endmodule