module comparator_8bit (
  input [7:0] a,
  input [7:0] b,
  output lt,
  output eq,
  output gt
);

  assign lt = (a < b);
  assign eq = (a == b);
  assign gt = (a > b);

endmodule