module top_module(
  input [3:0] A,
  input [3:0] B,
  input C,
  output [3:0] S
);wire [3:0] B_comp; // complement of B
  wire [3:0] carry_in; // carry in for subtraction
  wire [3:0] sum; // sum of A and B
  wire [3:0] diff; // difference of A and B

  // compute the complement of B
  assign B_comp = ~B + 1;

  // compute the carry in for subtraction
  assign carry_in = C ? B_comp : 1'b0;

  // compute the sum and difference
  assign sum = A + B;
  assign diff = A + B_comp + carry_in;

  // select the output based on the control input C
  assign S = C ? diff : sum;

endmodule