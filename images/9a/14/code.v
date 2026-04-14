module top_module(
  input En,
  input D,
  output Q,
  output not_Q
);wire n1, n2, n3, n4;

  // NOR gate 1
  nor(n1, D, En);

  // NOR gate 2
  nor(n2, n1, not_Q);

  // NOR gate 3
  nor(n3, n2, En);

  // NOR gate 4
  nor(n4, n3, Q);

  // Output assignments
  assign Q = n4;
  assign not_Q = n2;

endmodule