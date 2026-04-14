module top_module(A, B, S, Z);input A, B, S;
output reg Z; // Change output Z to reg type

  // Behavioral modeling
  always @ (A, B, S)
    if (S == 0)
      Z = A;
    else
      Z = B;

endmodule