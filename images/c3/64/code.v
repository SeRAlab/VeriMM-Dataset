module four_bit_adder(
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output [3:0] S,
  output Cout
);

  // Internal variables
  reg [3:0] sum;
  reg carry;

  // Implement the 4-bit adder
  always @(*) begin
    sum = A + B + Cin;
    carry = (sum > 15) ? 1 : 0;
  end

  // Assign outputs
  assign S = sum;
  assign Cout = carry;

endmodule