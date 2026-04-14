module top_module(
  input A1,
  input A2,
  input B1,
  input B2,
  output X
);wire n1, n2;

  // Use the correct module here instead of the missing one. 
  assign n1 = ~(A1 & A2 | B1 & B2);
  assign n2 = ~((A1 & A2) & n1);

  // XOR output
  assign X = n1 ^ n2;

endmodule