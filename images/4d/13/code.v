module top_module(A, B, subtract, result);input [3:0] A;
  input [3:0] B;
  input subtract;
  output [3:0] result;

  wire carry;
  wire [3:0] B_neg;

  assign B_neg = ~B + 1; // Two's complement of B

  assign carry = subtract ? ~(A & B_neg) & (A | B_neg) : (A & B) | (A & carry) | (B & carry);

  assign result = subtract ? A + B_neg + carry : A + B + carry;

endmodule