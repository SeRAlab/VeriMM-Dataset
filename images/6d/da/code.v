module top_module(A, B, BI, X, CO);parameter A_SIGNED = 0;
  parameter B_SIGNED = 0;
  parameter A_WIDTH  = 1;
  parameter B_WIDTH  = 1;
  parameter Y_WIDTH  = 1;

  input [A_WIDTH-1:0] A;
  input [B_WIDTH-1:0] B;
  input BI;
  output [Y_WIDTH-1:0] X, CO;

  wire [Y_WIDTH-1:0] sum = A + B;
  wire [Y_WIDTH-1:0] diff = A - B;

  assign X = BI ? diff : sum;

  // Carry-out for addition
  wire [Y_WIDTH:0] add_carry = {1'b0, sum};
  assign CO = add_carry[Y_WIDTH];

  // Borrow-out for subtraction
  wire [Y_WIDTH:0] sub_borrow = {1'b0, diff};
  assign CO = BI ? sub_borrow[Y_WIDTH] : CO;
endmodule