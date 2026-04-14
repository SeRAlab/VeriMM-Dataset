module top_module(
  input [31:0] val1,
  input [31:0] val2,
  output eq,
  output gt,
  output lt
);assign eq = (val1 == val2) ? 1'b1 : 1'b0;
  assign gt = (val1 > val2) ? 1'b1 : 1'b0;
  assign lt = (val1 < val2) ? 1'b1 : 1'b0;

endmodule