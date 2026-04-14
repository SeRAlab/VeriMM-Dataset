module top_module(Z, A, B, C, D, S0, S1);input A, B, C, D, S0, S1;
  output Z;

  wire n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20;

  // Implementing the 4-to-1 multiplexer using NAND gates
  nand #(1, 1) u1 (n1, A, S0);
  nand #(1, 1) u2 (n2, B, S0);
  nand #(1, 1) u3 (n3, C, S0);
  nand #(1, 1) u4 (n4, D, S0);

  nand #(1, 1) u5 (n5, n1, S1);
  nand #(1, 1) u6 (n6, n2, S1);
  nand #(1, 1) u7 (n7, n3, S1);
  nand #(1, 1) u8 (n8, n4, S1);

  nand #(1, 1) u9 (n9, n5, n6);
  nand #(1, 1) u10 (n10, n7, n8);

  nand #(1, 1) u11 (Z, n9, n10);

endmodule