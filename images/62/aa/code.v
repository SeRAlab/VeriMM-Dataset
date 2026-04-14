module top_module(
  input A,
  input B,
  input C,
  input D,
  output Y
);wire nand1, nand2, nand3;

  assign nand1 = ~(A & B);
  assign nand2 = ~(C & D);
  assign nand3 = ~(nand1 & nand2);
  assign Y = nand3;

endmodule