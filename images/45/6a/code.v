module top_module(
    input a, b,
    output cout, sum
);wire w1, w2, w3;

  // Implementing the sum output using NAND gates
  nand(w1, a, b);
  nand(w2, a, w1);
  nand(w3, b, w1);
  nand(sum, w2, w3);

  // Implementing the carry-out output using NAND gates
  nand(cout, w1, w1);

endmodule