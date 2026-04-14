module top_module(
  input a,
  input b,
  output y
);wire nand1_out;
  wire nand2_out;

  nand nand1(nand1_out, a, b);
  nand nand2(y, nand1_out, nand1_out);

endmodule