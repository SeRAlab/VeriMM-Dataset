module top_module(Z, A, B);input A, B;
  output Z;
  wire W1, W2, W3;

  // Define the AOI21 functionality
  wire nand1_out, nand2_out, nand3_out;

  // NAND gates based on AOI21 functionality
  assign nand1_out = ~(A & B);
  assign nand2_out = ~(A & nand1_out);
  assign nand3_out = ~(B & nand1_out);
  assign Z = ~(nand2_out & nand3_out);

endmodule