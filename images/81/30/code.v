module top_module(
  input A,
  input B,
  input [1:0] SEL,
  output C
);// Define logical operators based on SEL input signal
  wire AND = A & B;
  wire OR = A | B;
  wire XOR = A ^ B;
  wire NOT = ~A;

  // Compute output signal C based on input signals A and B and SEL control signal
  assign C = (SEL == 0) ? AND :
            (SEL == 1) ? OR :
            (SEL == 2) ? XOR :
            (SEL == 3) ? NOT :
            1'bx; // default value for invalid SEL input

endmodule