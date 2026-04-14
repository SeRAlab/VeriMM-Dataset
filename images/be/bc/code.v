module top_module(
  input A,
  input B,
  input CLR,
  output Y,
  output Yn
);wire nand_out;

  assign nand_out = ~(A & B);

  assign Y = CLR ? 1'b0 : nand_out;
  assign Yn = CLR ? 1'b1 : ~nand_out;

endmodule