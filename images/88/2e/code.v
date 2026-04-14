module top_module(
  input A,
  input B,
  input C,
  input D,
  output Y
);wire AB;
  wire CD;

  // Implement NOR logic
  assign AB = ~(A | B);  // NOR logic for A and B
  assign CD = ~(C | D);  // NOR logic for C and D
  assign Y = ~(AB | CD); // Final NOR logic for AB and CD

endmodule