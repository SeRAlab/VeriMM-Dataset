module top_module(Z, A, B, C, D);output Z;
  input A, B, C, D;

  wire nand1_out, nand2_out, nand3_out;

  nand #(5, 5) nand1 (nand1_out, A, B);
  nand #(5, 5) nand2 (nand2_out, C, D);
  nand #(5, 5) nand3 (Z, nand1_out, nand2_out, 1);
endmodule