module top_module(a, b, y);input a;
  input b;
  output y;

  wire n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12;

  nand(n1, a, b);
  nand(n2, a, n1);
  nand(n3, b, n1);
  nand(n4, n2, n2);
  nand(n5, n3, n3);
  nand(n6, n4, n5);
  nand(n7, n6, n6);
  nor(n8, a, b);
  nor(n9, a, n1);
  nor(n10, b, n1);
  nor(n11, n9, n9);
  nor(n12, n10, n10);
  nor(y, n11, n12);

endmodule