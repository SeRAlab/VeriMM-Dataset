module top_module(
  input a,
  input b,
  output out
);wire na, nb, nand1, nand2, nand3, nand4;

  // Implementing NOT gates using NOR gates
  nor(na, a, a);
  nor(nb, b, b);

  // Implementing NAND gates using NOR gates
  nor(nand1, a, nb);
  nor(nand2, na, b);

  // Implementing OR gate using NOR gates
  nor(nand3, nand1, nand2);

  // Implementing NOT gate using NOR gate
  nor(nand4, nand3, nand3);

  // Output of XOR gate
  assign out = nand4;

endmodule