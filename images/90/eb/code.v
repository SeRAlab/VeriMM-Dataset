module top_module(
  input A,
  input B,
  output YC,
  output YS
);assign YC = A ^ B; // Half Adder Carry Output
assign YS = A & B; // Half Adder Sum Output

endmodule