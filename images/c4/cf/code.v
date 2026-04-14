module full_adder (
  input A,
  input B,
  input C_in,
  output Sum,
  output C_out
);

  wire HA1_Sum, HA1_C_out, HA2_C_out;

  // Instantiate two half-adders
  half_adder HA1(.A(A), .B(B), .Sum(HA1_Sum), .C_out(HA1_C_out));
  half_adder HA2(.A(HA1_Sum), .B(C_in), .Sum(Sum), .C_out(HA2_C_out));

  // Calculate the final carry-out
  assign C_out = HA1_C_out | HA2_C_out;

endmodule

// Half-adder module
module half_adder (
  input A,
  input B,
  output Sum,
  output C_out
);

  assign Sum = A ^ B;
  assign C_out = A & B;

endmodule