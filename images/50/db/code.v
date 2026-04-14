module top_module(
  input A,
  input B,
  output SUM,
  output CARRY,
  input VPWR,
  input VGND,
  input VPB,
  input VNB
);// Define the behavioral implementation of a half adder
  assign SUM = A ^ B;      // Sum is A XOR B
  assign CARRY = A & B;    // Carry is A AND B

endmodule