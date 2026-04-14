module top_module(
  input A,
  input B,
  output S,
  output Cout
);assign S = A ^ B;     // Sum output
  assign Cout = A & B;  // Carry output
endmodule